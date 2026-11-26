/**
 * rdp-pointer: minimal FreeRDP client that sends pointer motion and click
 * events to a gnome-remote-desktop RDP server.
 *
 * Uses the full FreeRDP client context initialization to ensure channel
 * subsystem (DRDYNVC) is properly registered, as gnome-remote-desktop requires.
 *
 * Usage: rdp-pointer <argsfile> <x> <y> [click|move]
 *   <argsfile> contains xfreerdp-style arguments, one per line:
 *     /v:host[:port]  /u:user  /p:pass  /cert:fingerprint:sha256:<hex>  /w:1920  /h:1080  etc.
 *
 * Copyright (c) 2026 Howard.
 * SPDX-License-Identifier: MIT
 * Team-authored code under the repository root licence (MIT, LICENSE at
 * repo root). It links
 * against libfreerdp3 / libfreerdp-client3, which carry their own Apache-2.0
 * licence; that link is dynamic against the unmodified distro library, and no
 * FreeRDP source is vendored or compiled in.
 * Build: gcc -o rdp-pointer rdp-pointer.c $(pkg-config --cflags --libs freerdp-client3)
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

/* Minimal entry points to get full client context with channels */
static int my_client_new(freerdp *instance, rdpContext *context)
{
	(void)instance; (void)context;
	return 1; /* success */
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
	argv[count++] = "rdp-pointer"; /* argv[0] placeholder */
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

int main(int argc, char *argv[])
{
	if (argc < 4) {
		fprintf(stderr,
			"usage: rdp-pointer <argsfile> <x> <y> [click|move]\n");
		return 1;
	}

	const char *argsfile = argv[1];
	const char *x_str = argv[2];
	const char *y_str = argv[3];
	const char *action = (argc >= 5) ? argv[4] : "click";

	if (strcmp(action, "click") != 0 && strcmp(action, "move") != 0) {
		fprintf(stderr, "error: action must be 'click' or 'move'\n");
		return 1;
	}

	/* Parse xfreerdp-style arguments */
	char *cmdline[MAX_ARGS];
	int cmdline_argc = parse_args_file(argsfile, cmdline, MAX_ARGS);
	if (cmdline_argc < 2) {
		fprintf(stderr, "error: args file has no arguments\n");
		return 1;
	}

	/* Create settings and parse args */
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

	/* Ensure dynamic channels (DRDYNVC) are enabled - gnome-remote-desktop requires */
	freerdp_settings_set_bool(settings, FreeRDP_SupportDynamicChannels, TRUE);

	/* Build entry points for full client context (includes channels) */
	RDP_CLIENT_ENTRY_POINTS entry = {0};
	entry.Size = sizeof(entry);
	entry.Version = RDP_CLIENT_INTERFACE_VERSION;
	entry.settings = settings;
	entry.ContextSize = sizeof(rdpClientContext);
	entry.ClientNew = my_client_new;
	entry.ClientFree = my_client_free;
	entry.GlobalInit = NULL;
	entry.GlobalUninit = NULL;
	entry.ClientStart = NULL;
	entry.ClientStop = NULL;

	rdpContext *context = freerdp_client_context_new(&entry);
	if (!context) {
		fprintf(stderr, "error: freerdp_client_context_new failed\n");
		for (int i = 1; i < cmdline_argc; i++) free(cmdline[i]);
		freerdp_settings_free(settings);
		return 1;
	}

	freerdp *instance = context->instance;
	settings = context->settings;

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

	printf("connected. sending pointer %s at (%s, %s) ...\n", action, x_str, y_str);

	rdpInput *input = context->input;
	UINT16 x = (UINT16)atoi(x_str);
	UINT16 y = (UINT16)atoi(y_str);

	/* Delay for session activation */
	usleep(500000);  /* 500 ms */

	if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_MOVE, x, y)) {
		fprintf(stderr, "error: failed to send pointer move\n");
		goto cleanup;
	}

	if (strcmp(action, "click") == 0) {
		usleep(100000);
		if (!freerdp_input_send_mouse_event(input,
		                                   PTR_FLAGS_DOWN | PTR_FLAGS_BUTTON1,
		                                   x, y)) {
			fprintf(stderr, "error: failed to send button press\n");
			goto cleanup;
		}
		usleep(80000);
		if (!freerdp_input_send_mouse_event(input, PTR_FLAGS_BUTTON1, x, y)) {
			fprintf(stderr, "error: failed to send button release\n");
			goto cleanup;
		}
	}

	printf("pointer event(s) sent. waiting 1s for effect ...\n");
	sleep(1);

cleanup:
	freerdp_disconnect(instance);
	for (int i = 1; i < cmdline_argc; i++) free(cmdline[i]);
	freerdp_client_context_free(context);
	printf("done.\n");
	return 0;
}
