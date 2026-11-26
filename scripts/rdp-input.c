/**
 * rdp-input: scripted keyboard and pointer injection for a gnome-remote-desktop
 * RDP session, built on FreeRDP 3. Derived from rdp-pointer.c (same team, same
 * license); kept as a separate file so the proven rdp-pointer behaviour stays
 * available unchanged.
 *
 * Unlike rdp-pointer, this client holds one connection open while it plays a
 * whole event script, which is required for interactions that depend on
 * transient UI state (a Win32 menu that closes when the session drops).
 *
 * Usage: rdp-input <argsfile> <event> [<event> ...]
 *   <argsfile>  xfreerdp-style arguments, one per line:
 *                 /v:host[:port]  /u:user  /p:pass  /cert:fingerprint:sha256:<hex>  /w:1920  /h:1080
 *   events:
 *     move  <x> <y>        pointer motion
 *     click <x> <y>        pointer motion + left button press and release
 *     type  <text>         one Unicode keyboard event pair per character
 *     key   <scancode>     raw RDP scancode press and release (decimal or 0x hex)
 *     keyx  <scancode>     same, with the extended-key flag
 *     keydown <scancode>   raw RDP scancode press only (modifier hold)
 *     keyup   <scancode>   raw RDP scancode release only
 *     wait  <ms>           hold the connection open for ms milliseconds
 *
 * Copyright (c) 2026 Howard.
 * SPDX-License-Identifier: MIT
 * Team-authored code under the repository root licence (MIT, LICENSE at
 * repo root). It links
 * against libfreerdp3 / libfreerdp-client3, which carry their own Apache-2.0
 * licence; that link is dynamic against the unmodified distro library, and no
 * FreeRDP source is vendored or compiled in.
 * Build: gcc -o rdp-input rdp-input.c $(pkg-config --cflags --libs freerdp-client3)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <freerdp/freerdp.h>
#include <freerdp/input.h>
#include <freerdp/settings.h>
#include <freerdp/error.h>
#include <freerdp/client.h>
#include <freerdp/client/cmdline.h>
#include <freerdp/client/channels.h>

#include <winpr/wtypes.h>

#define MAX_ARGS 32
#define MAX_LINE 512

static int my_client_new(freerdp *instance, rdpContext *context)
{
	(void)instance; (void)context;
	return 1;
}

static void my_client_free(freerdp *instance, rdpContext *context)
{
	(void)instance; (void)context;
}

static int parse_args_file(const char *path, char **argv, int max_args)
{
	FILE *f = fopen(path, "r");
	if (!f) {
		fprintf(stderr, "error: cannot open args file: %s\n", path);
		return -1;
	}
	int count = 0;
	argv[count++] = "rdp-input"; /* argv[0] placeholder */
	char line[MAX_LINE];
	while (fgets(line, sizeof(line), f) && count < max_args) {
		size_t len = strlen(line);
		while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r'))
			line[--len] = '\0';
		if (len == 0) continue;
		argv[count] = strdup(line);
		if (!argv[count]) { fclose(f); return -1; }
		count++;
	}
	fclose(f);
	return count;
}

/* Decode the next UTF-8 sequence from *p, advancing *p. Returns the code point. */
static unsigned int next_utf8(const char **p)
{
	const unsigned char *s = (const unsigned char *)*p;
	if (!*s) { return 0; }
	unsigned int cp;
	unsigned int extra;
	if (s[0] < 0x80) { cp = s[0]; extra = 0; }
	else if ((s[0] & 0xE0) == 0xC0) { cp = s[0] & 0x1F; extra = 1; }
	else if ((s[0] & 0xF0) == 0xE0) { cp = s[0] & 0x0F; extra = 2; }
	else if ((s[0] & 0xF8) == 0xF0) { cp = s[0] & 0x07; extra = 3; }
	else { /* invalid lead byte: skip it */ *p += 1; return 0; }
	for (unsigned int i = 0; i < extra; i++) {
		if ((s[1 + i] & 0xC0) != 0x80) { *p += 1; return 0; }
		cp = (cp << 6) | (s[1 + i] & 0x3F);
	}
	*p += 1 + extra;
	return cp;
}

static BOOL send_type(rdpInput *input, const char *text)
{
	const char *p = text;
	unsigned int cp;
	while ((cp = next_utf8(&p)) != 0) {
		if (cp > 0xFFFF) { /* outside the BMP: the RDP Unicode event cannot carry it */
			fprintf(stderr, "error: code point U+%X outside the BMP\n", cp);
			return FALSE;
		}
		if (!freerdp_input_send_unicode_keyboard_event(input, 0, (UINT16)cp)) {
			fprintf(stderr, "error: unicode key down failed for U+%X\n", cp);
			return FALSE;
		}
		usleep(20000);
		if (!freerdp_input_send_unicode_keyboard_event(input, KBD_FLAGS_RELEASE, (UINT16)cp)) {
			fprintf(stderr, "error: unicode key release failed for U+%X\n", cp);
			return FALSE;
		}
		usleep(20000);
	}
	return TRUE;
}

/* Press only: modifier hold. */
static BOOL send_keydown(rdpInput *input, const char *scancode_str, BOOL extended)
{
	UINT8 code = (UINT8)strtoul(scancode_str, NULL, 0);
	UINT16 flags = KBD_FLAGS_DOWN | (extended ? KBD_FLAGS_EXTENDED : 0);
	if (!freerdp_input_send_keyboard_event(input, flags, code)) {
		fprintf(stderr, "error: keydown failed for scancode %s\n", scancode_str);
		return FALSE;
	}
	return TRUE;
}

/* Release only: modifier unhold. */
static BOOL send_keyup(rdpInput *input, const char *scancode_str, BOOL extended)
{
	UINT8 code = (UINT8)strtoul(scancode_str, NULL, 0);
	UINT16 flags = KBD_FLAGS_RELEASE | (extended ? KBD_FLAGS_EXTENDED : 0);
	if (!freerdp_input_send_keyboard_event(input, flags, code)) {
		fprintf(stderr, "error: keyup failed for scancode %s\n", scancode_str);
		return FALSE;
	}
	return TRUE;
}

/* Press and release one key by RDP scancode. 'keyx' adds KBD_FLAGS_EXTENDED.
 * freerdp_input_send_keyboard_event takes explicit KBD_FLAGS_* values, so the
 * extended-key semantics never depend on a positional argument's meaning. */
static BOOL send_key(rdpInput *input, const char *scancode_str, BOOL extended)
{
	UINT8 code = (UINT8)strtoul(scancode_str, NULL, 0);
	UINT16 down = KBD_FLAGS_DOWN | (extended ? KBD_FLAGS_EXTENDED : 0);
	UINT16 up = KBD_FLAGS_RELEASE | (extended ? KBD_FLAGS_EXTENDED : 0);
	if (!freerdp_input_send_keyboard_event(input, down, code)) {
		fprintf(stderr, "error: key down failed for scancode %s\n", scancode_str);
		return FALSE;
	}
	usleep(40000);
	if (!freerdp_input_send_keyboard_event(input, up, code)) {
		fprintf(stderr, "error: key release failed for scancode %s\n", scancode_str);
		return FALSE;
	}
	return TRUE;
}

static BOOL send_click(rdpInput *input, UINT16 x, UINT16 y)
{
	if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_MOVE, x, y)) {
		fprintf(stderr, "error: pointer move failed\n");
		return FALSE;
	}
	usleep(80000);
	if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_DOWN | PTR_FLAGS_BUTTON1, x, y)) {
		fprintf(stderr, "error: button press failed\n");
		return FALSE;
	}
	usleep(80000);
	if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_BUTTON1, x, y)) {
		fprintf(stderr, "error: button release failed\n");
		return FALSE;
	}
	return TRUE;
}

int main(int argc, char *argv[])
{
	if (argc < 3) {
		fprintf(stderr,
			"usage: rdp-input <argsfile> <event> [<event> ...]\n"
			"  events: move x y | click x y | type text | key scancode | keyx scancode\n"
			"          | keydown scancode | keyup scancode | wait ms\n");
		return 1;
	}

	const char *argsfile = argv[1];

	char *cmdline[MAX_ARGS];
	int cmdline_argc = parse_args_file(argsfile, cmdline, MAX_ARGS);
	if (cmdline_argc < 2) {
		fprintf(stderr, "error: args file has no arguments\n");
		return 1;
	}

	rdpSettings *settings = freerdp_settings_new(0);
	if (!settings) {
		fprintf(stderr, "error: freerdp_settings_new failed\n");
		return 1;
	}

	int rc = freerdp_client_settings_parse_command_line_arguments(settings,
	                                                              cmdline_argc,
	                                                              cmdline,
	                                                              FALSE);
	if (rc < 0) {
		fprintf(stderr, "error: failed to parse args (rc=%d)\n", rc);
		freerdp_settings_free(settings);
		return 1;
	}

	/* gnome-remote-desktop requires the dynamic virtual channel subsystem. */
	freerdp_settings_set_bool(settings, FreeRDP_SupportDynamicChannels, TRUE);

	RDP_CLIENT_ENTRY_POINTS entry = {0};
	entry.Size = sizeof(entry);
	entry.Version = RDP_CLIENT_INTERFACE_VERSION;
	entry.settings = settings;
	entry.ContextSize = sizeof(rdpClientContext);
	entry.ClientNew = my_client_new;
	entry.ClientFree = my_client_free;

	rdpContext *context = freerdp_client_context_new(&entry);
	if (!context) {
		fprintf(stderr, "error: freerdp_client_context_new failed\n");
		for (int i = 1; i < cmdline_argc; i++) free(cmdline[i]);
		freerdp_settings_free(settings);
		return 1;
	}

	freerdp *instance = context->instance;
	printf("connecting (args from %s) ...\n", argsfile);

	if (!freerdp_connect(instance)) {
		UINT32 err = freerdp_get_last_error(context);
		const char *name = freerdp_get_last_error_name(err);
		const char *desc = freerdp_get_last_error_string(err);
		fprintf(stderr, "error: connect failed (%s): %s\n",
		        name ? name : "unknown", desc ? desc : "no detail");
		for (int i = 1; i < cmdline_argc; i++) free(cmdline[i]);
		freerdp_client_context_free(context);
		return 1;
	}

	rdpInput *input = context->input;
	usleep(600000); /* let the session finish activating before injecting */

	int failed = 0;
	for (int i = 2; i < argc && !failed; i++) {
		const char *ev = argv[i];
		if (strcmp(ev, "move") == 0 && i + 2 < argc) {
			UINT16 x = (UINT16)atoi(argv[++i]);
			UINT16 y = (UINT16)atoi(argv[++i]);
			printf("event: move (%u, %u)\n", x, y);
			if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_MOVE, x, y)) failed = 1;
		} else if (strcmp(ev, "click") == 0 && i + 2 < argc) {
			UINT16 x = (UINT16)atoi(argv[++i]);
			UINT16 y = (UINT16)atoi(argv[++i]);
			printf("event: click (%u, %u)\n", x, y);
			if (!send_click(input, x, y)) failed = 1;
		} else if (strcmp(ev, "type") == 0 && i + 1 < argc) {
			const char *text = argv[++i];
			printf("event: type \"%s\"\n", text);
			if (!send_type(input, text)) failed = 1;
		} else if (strcmp(ev, "key") == 0 && i + 1 < argc) {
			const char *code = argv[++i];
			printf("event: key %s\n", code);
			if (!send_key(input, code, FALSE)) failed = 1;
		} else if (strcmp(ev, "keyx") == 0 && i + 1 < argc) {
			const char *code = argv[++i];
			printf("event: keyx %s\n", code);
			if (!send_key(input, code, TRUE)) failed = 1;
		} else if (strcmp(ev, "keydown") == 0 && i + 1 < argc) {
			const char *code = argv[++i];
			printf("event: keydown %s\n", code);
			if (!send_keydown(input, code, FALSE)) failed = 1;
		} else if (strcmp(ev, "keyup") == 0 && i + 1 < argc) {
			const char *code = argv[++i];
			printf("event: keyup %s\n", code);
			if (!send_keyup(input, code, FALSE)) failed = 1;
		} else if (strcmp(ev, "drag") == 0 && i + 4 < argc) {
			/* drag x1 y1 x2 y2 [x3 y3 ...] — press at first, move through
			 * intermediate points with button held, release at last. */
			int rest = argc - i - 1;
			int pairs = rest / 2;
			printf("event: drag (%d waypoints)\n", pairs);
			UINT16 sx = (UINT16)atoi(argv[++i]);
			UINT16 sy = (UINT16)atoi(argv[++i]);
			if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_MOVE, sx, sy)) failed = 1;
			usleep(50000);
			if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_DOWN | PTR_FLAGS_BUTTON1, sx, sy)) failed = 1;
			usleep(50000);
			for (int w = 1; w < pairs && !failed; w++) {
				UINT16 wx = (UINT16)atoi(argv[++i]);
				UINT16 wy = (UINT16)atoi(argv[++i]);
				if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_MOVE | PTR_FLAGS_DOWN | PTR_FLAGS_BUTTON1, wx, wy)) failed = 1;
				usleep(40000);
			}
			/* release at last position */
			if (!failed) {
				if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_BUTTON1 | PTR_FLAGS_MOVE, sx, sy)) failed = 1;
			}
		} else if (strcmp(ev, "wait") == 0 && i + 1 < argc) {
			int ms = atoi(argv[++i]);
			printf("event: wait %d ms\n", ms);
			usleep((unsigned int)ms * 1000u);
		} else {
			fprintf(stderr, "error: unknown or incomplete event: %s\n", ev);
			failed = 1;
		}
	}

	freerdp_disconnect(instance);
	for (int i = 1; i < cmdline_argc; i++) free(cmdline[i]);
	freerdp_client_context_free(context);
	printf("done%s.\n", failed ? " WITH ERRORS" : "");
	return failed ? 1 : 0;
}
