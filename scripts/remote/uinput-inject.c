/* rt_uinput.c - TASK-0042 dispatch P1: kernel-level /dev/uinput injection helper.
 *
 * Copyright (c) 2026 Howard.
 * SPDX-License-Identifier: MIT
 * Team-authored code under the repository root licence (MIT, LICENSE at
 * repo root). Compiles
 * against kernel UAPI headers only; the Linux syscall note places normal
 * userspace use of those headers outside derived work, and the injector
 * links no userspace library beyond libc.
 *
 * Creates short-lived virtual input devices through /dev/uinput and replays a
 * command file, so injected events enter at the kernel input layer rather than
 * through gnome-remote-desktop's compositor-level virtual device.
 *
 * Build on the controller (the target has no compiler) and copy the binary:
 *   gcc -O2 -Wall -o rt_uinput rt_uinput.c
 * Run on the target as root:
 *   sudo -n /tmp/rt_uinput --probe
 *   sudo -n /tmp/rt_uinput --script /tmp/p1-cmds.txt [--res 1920x1080]
 *
 * Command file, one command per line, '#' starts a comment:
 *   key <name>            keyboard press then release
 *   down <name> / up <name>
 *   mv <x> <y>            absolute motion (pen-tablet device)
 *   click <x> <y>         absolute motion then stylus press and release
 *   tap <x> <y>           touchscreen touch press and release
 *   drag <x1> <y1> <x2> <y2> [steps]
 *   wait <ms>
 *
 * No credential is read. Nothing is written to disk. Every device created here
 * is destroyed before exit.
 */

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <linux/input.h>
#include <linux/uinput.h>

#define MAX_CMDS 256
#define MAX_LINE 256

/* The target drops events emitted in the same millisecond as UI_DEV_CREATE
 * (TASK-0042 dispatch P1: the no-settle attempt failed, the settle-delayed run
 * worked, DEMO-LOG 2026-11-22). The wrapper rt-uinput documents a 1800 ms
 * settle; this named constant is where the helper actually carries it, between
 * device creation and the first event. */
#define SETTLE_MS 1800

/* Keyboard codes used by this dispatch. Values are linux KEY_* event codes. */
struct keyname { const char *name; int code; };
static const struct keyname KEYS[] = {
    {"ESC", KEY_ESC}, {"ENTER", KEY_ENTER}, {"SPACE", KEY_SPACE},
    {"TAB", KEY_TAB}, {"BACKSPACE", KEY_BACKSPACE},
    {"LEFTCTRL", KEY_LEFTCTRL}, {"LEFTSHIFT", KEY_LEFTSHIFT},
    {"LEFTALT", KEY_LEFTALT}, {"LEFTMETA", KEY_LEFTMETA},
    {"UP", KEY_UP}, {"DOWN", KEY_DOWN}, {"LEFT", KEY_LEFT}, {"RIGHT", KEY_RIGHT},
    {"F1", KEY_F1}, {"F10", KEY_F10},
    {"A", KEY_A}, {"B", KEY_B}, {"C", KEY_C}, {"D", KEY_D}, {"E", KEY_E},
    {"F", KEY_F}, {"G", KEY_G}, {"H", KEY_H}, {"I", KEY_I}, {"J", KEY_J},
    {"K", KEY_K}, {"L", KEY_L}, {"M", KEY_M}, {"N", KEY_N}, {"O", KEY_O},
    {"P", KEY_P}, {"Q", KEY_Q}, {"R", KEY_R}, {"S", KEY_S}, {"T", KEY_T},
    {"U", KEY_U}, {"V", KEY_V}, {"W", KEY_W}, {"X", KEY_X}, {"Y", KEY_Y},
    {"Z", KEY_Z}, {"1", KEY_1}, {"2", KEY_2}, {"3", KEY_3}, {"4", KEY_4},
    {"5", KEY_5}, {"6", KEY_6}, {"7", KEY_7}, {"8", KEY_8}, {"9", KEY_9},
    {NULL, 0},
};

static int res_x = 1920;
static int res_y = 1080;

static int key_code(const char *name)
{
    for (const struct keyname *k = KEYS; k->name; k++)
        if (strcmp(k->name, name) == 0)
            return k->code;
    return -1;
}

struct dev {
    int fd;              /* shared /dev/uinput fd */
    int created;
    const char *name;
};

static int set_bits(int fd, int ev, const int *codes, int n)
{
    if (ioctl(fd, UI_SET_EVBIT, ev) != 0) {
        fprintf(stderr, "[rt-uinput] UI_SET_EVBIT %d failed errno=%d\n", ev, errno);
        return -1;
    }
    for (int i = 0; i < n; i++) {
        if (ioctl(fd, UI_SET_KEYBIT, codes[i]) != 0) {
            fprintf(stderr, "[rt-uinput] UI_SET_KEYBIT %d failed errno=%d\n", codes[i], errno);
            return -1;
        }
    }
    return 0;
}

/* Create one device. Slot kinds: keyboard, pen tablet, touchscreen, relative mouse. */
static int create_dev(int fd, const char *name, int is_touch, int is_pen, int is_mouse)
{
    static const int kbd_keys[] = {
        KEY_ESC, KEY_ENTER, KEY_SPACE, KEY_TAB, KEY_BACKSPACE,
        KEY_LEFTCTRL, KEY_LEFTSHIFT, KEY_LEFTALT, KEY_LEFTMETA,
        KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_F1, KEY_F10,
        KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H, KEY_I,
        KEY_J, KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R,
        KEY_S, KEY_T, KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z,
        KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9,
    };
    static const int pen_keys[] = { BTN_TOOL_PEN, BTN_STYLUS, BTN_STYLUS2 };
    static const int touch_keys[] = { BTN_TOOL_FINGER, BTN_TOOL_DOUBLETAP, BTN_TOUCH };
    static const int mouse_keys[] = { BTN_LEFT, BTN_RIGHT };

    const int *keys;
    int nkeys;
    if (is_touch) { keys = touch_keys; nkeys = (int)sizeof(touch_keys) / sizeof(int); }
    else if (is_pen) { keys = pen_keys; nkeys = (int)sizeof(pen_keys) / sizeof(int); }
    else if (is_mouse) { keys = mouse_keys; nkeys = (int)sizeof(mouse_keys) / sizeof(int); }
    else { keys = kbd_keys; nkeys = (int)sizeof(kbd_keys) / sizeof(int); }

    if (set_bits(fd, EV_KEY, keys, nkeys) != 0)
        return -1;

    if (is_mouse) {
        if (ioctl(fd, UI_SET_EVBIT, EV_REL) != 0 ||
            ioctl(fd, UI_SET_RELBIT, REL_X) != 0 ||
            ioctl(fd, UI_SET_RELBIT, REL_Y) != 0) {
            fprintf(stderr, "[rt-uinput] rel setup failed errno=%d\n", errno);
            return -1;
        }
    }

    if (is_touch || is_pen) {
        if (ioctl(fd, UI_SET_EVBIT, EV_ABS) != 0 ||
            ioctl(fd, UI_SET_ABSBIT, ABS_X) != 0 ||
            ioctl(fd, UI_SET_ABSBIT, ABS_Y) != 0 ||
            ioctl(fd, UI_SET_EVBIT, EV_MSC) != 0 ||
            ioctl(fd, UI_SET_MSCBIT, MSC_SCAN) != 0) {
            fprintf(stderr, "[rt-uinput] abs/msc setup failed errno=%d\n", errno);
            return -1;
        }
        if (is_touch) {
            /* Multitouch axes so libinput classifies this as a touchscreen. */
            int mt[4] = { ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_X, ABS_MT_POSITION_Y };
            for (int i = 0; i < 4; i++)
                if (ioctl(fd, UI_SET_ABSBIT, mt[i]) != 0) {
                    fprintf(stderr, "[rt-uinput] mt abs setup failed errno=%d\n", errno);
                    return -1;
                }
        }
    }

    struct uinput_setup uset;
    memset(&uset, 0, sizeof(uset));
    snprintf(uset.name, UINPUT_MAX_NAME_SIZE, "%s", name);
    uset.id.bustype = BUS_VIRTUAL;
    uset.id.vendor = 0x1;
    uset.id.product = 0x1;
    uset.id.version = 0x1;
    if (ioctl(fd, UI_DEV_SETUP, &uset) != 0) {
        fprintf(stderr, "[rt-uinput] UI_DEV_SETUP %s failed errno=%d\n", name, errno);
        return -1;
    }

    if (is_touch || is_pen) {
        /* Axis code plus its maximum. X axes use res_x, Y axes use res_y. */
        struct axis { int code; int is_y; int max; };
        struct axis axes[6];
        int naxes = 0;
        axes[naxes++] = (struct axis){ ABS_X, 0, 0 };
        axes[naxes++] = (struct axis){ ABS_Y, 1, 0 };
        if (is_touch) {
            axes[naxes++] = (struct axis){ ABS_MT_SLOT, 0, 1 };
            axes[naxes++] = (struct axis){ ABS_MT_TRACKING_ID, 0, 255 };
            axes[naxes++] = (struct axis){ ABS_MT_POSITION_X, 0, 0 };
            axes[naxes++] = (struct axis){ ABS_MT_POSITION_Y, 1, 0 };
        }
        for (int i = 0; i < naxes; i++) {
            struct uinput_abs_setup ab;
            memset(&ab, 0, sizeof(ab));
            ab.code = axes[i].code;
            ab.absinfo.value = 0;
            ab.absinfo.minimum = 0;
            ab.absinfo.maximum = axes[i].max ? axes[i].max
                                             : (axes[i].is_y ? res_y - 1 : res_x - 1);
            ab.absinfo.fuzz = 0;
            ab.absinfo.flat = 0;
            ab.absinfo.resolution = 0;
            if (ioctl(fd, UI_ABS_SETUP, &ab) != 0) {
                fprintf(stderr, "[rt-uinput] UI_ABS_SETUP axis %d failed errno=%d\n", ab.code, errno);
                return -1;
            }
        }
    }

    if (ioctl(fd, UI_DEV_CREATE) != 0) {
        fprintf(stderr, "[rt-uinput] UI_DEV_CREATE %s failed errno=%d\n", name, errno);
        return -1;
    }
    printf("[rt-uinput] created %s\n", name);
    fflush(stdout);
    return 0;
}

static int destroy_dev(int fd)
{
    if (ioctl(fd, UI_DEV_DESTROY) != 0) {
        fprintf(stderr, "[rt-uinput] UI_DEV_DESTROY failed errno=%d\n", errno);
        return -1;
    }
    return 0;
}

static void emit(int fd, unsigned short type, unsigned short code, int value)
{
    struct input_event ev;
    memset(&ev, 0, sizeof(ev));
    ev.type = type;
    ev.code = code;
    ev.value = value;
    if (write(fd, &ev, sizeof(ev)) != sizeof(ev))
        fprintf(stderr, "[rt-uinput] event write failed errno=%d\n", errno);
}

static void syn(int fd) { emit(fd, EV_SYN, SYN_REPORT, 0); }

static void sleep_ms(int ms)
{
    struct timespec ts = { .tv_sec = ms / 1000, .tv_nsec = (long)(ms % 1000) * 1000000L };
    nanosleep(&ts, NULL);
}

static int abs_motion(int fd, int x, int y)
{
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x > res_x - 1) x = res_x - 1;
    if (y > res_y - 1) y = res_y - 1;
    emit(fd, EV_ABS, ABS_X, x);
    emit(fd, EV_ABS, ABS_Y, y);
    emit(fd, EV_MSC, MSC_SCAN, y * 4096 + x);
    syn(fd);
    return 0;
}

int main(int argc, char **argv)
{
    const char *script = NULL;
    int probe = 0;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--probe") == 0) probe = 1;
        else if (strcmp(argv[i], "--script") == 0 && i + 1 < argc) script = argv[++i];
        else if (strcmp(argv[i], "--res") == 0 && i + 1 < argc) {
            if (sscanf(argv[++i], "%dx%d", &res_x, &res_y) != 2) {
                fprintf(stderr, "[rt-uinput] bad --res\n");
                return 2;
            }
        } else {
            fprintf(stderr, "[rt-uinput] unknown argument %s\n", argv[i]);
            return 2;
        }
    }

    char cmds[MAX_CMDS][MAX_LINE];
    int ncmds = 0;
    if (script) {
        FILE *fh = fopen(script, "r");
        if (!fh) { fprintf(stderr, "[rt-uinput] cannot open script: %s\n", strerror(errno)); return 2; }
        char line[MAX_LINE];
        while (fgets(line, sizeof(line), fh) && ncmds < MAX_CMDS) {
            char *hash = strchr(line, '#');
            if (hash) *hash = '\0';
            if (strlen(line) <= 1) continue;
            snprintf(cmds[ncmds], MAX_LINE, "%s", line);
            ncmds++;
        }
        fclose(fh);
    }

    int want_kbd = probe, want_pen = probe, want_touch = probe, want_mouse = probe;
    for (int i = 0; i < ncmds; i++) {
        char verb[64] = "";
        sscanf(cmds[i], "%63s", verb);
        if (!strcmp(verb, "key") || !strcmp(verb, "down") || !strcmp(verb, "up")) want_kbd = 1;
        if (!strcmp(verb, "mv") || !strcmp(verb, "click")) want_pen = 1;
        if (!strcmp(verb, "tap") || !strcmp(verb, "drag") || !strcmp(verb, "mtap")) want_touch = 1;
        if (!strcmp(verb, "rmove") || !strcmp(verb, "rclick")) want_mouse = 1;
    }

    printf("[rt-uinput] kbd=%d pen=%d touch=%d mouse=%d res=%dx%d cmds=%d\n",
           want_kbd, want_pen, want_touch, want_mouse, res_x, res_y, ncmds);
    fflush(stdout);

    int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
    if (fd < 0) {
        fprintf(stderr, "[rt-uinput] open /dev/uinput failed errno=%d (%s)\n", errno, strerror(errno));
        return 1;
    }
    unsigned int ver = 0;
    if (ioctl(fd, UI_GET_VERSION, &ver) == 0)
        printf("[rt-uinput] uinput protocol version %u\n", ver);

    int ncreated = 0;

    /* Each open of /dev/uinput gives one uinput device context, and events written to an
     * fd are delivered by the device created on that fd. So one fd per device:
     * slot 0 keyboard, slot 1 pen tablet, slot 2 touchscreen. */
    int fds[4] = { -1, -1, -1, -1 };
    int want[4] = { want_kbd, want_pen, want_touch, want_mouse };
    const char *names[4] = { "rt-kbd", "rt-pen", "rt-touch", "rt-mouse" };
    for (int which = 0; which < 4; which++) {
        if (!want[which]) continue;
        int f = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
        if (f < 0) { fprintf(stderr, "[rt-uinput] reopen failed errno=%d\n", errno); break; }
        if (create_dev(f, names[which], which == 2, which == 1, which == 3) != 0) { close(f); continue; }
        fds[which] = f;
        ncreated++;
    }
    close(fd);
    fd = -1;

    int rc = 0;
    if (ncreated == 0) {
        fprintf(stderr, "[rt-uinput] no device created\n");
        rc = 1;
    }

    if (rc == 0 && !probe) {
        /* Settle SETTLE_MS after UI_DEV_CREATE before the first event: same-
         * millisecond events are dropped on the target (TASK-0042 dispatch P1).
         * The probe path emits nothing, so it settles nothing. */
        sleep_ms(SETTLE_MS);
        if (fds[1] >= 0) { emit(fds[1], EV_KEY, BTN_TOOL_PEN, 1); syn(fds[1]); }
        for (int i = 0; i < ncmds && rc == 0; i++) {
            char verb[64];
            char a0[64];
            int n = sscanf(cmds[i], "%63s", verb);
            if (n < 1) continue;
            if (!strcmp(verb, "wait")) {
                int ms = 0;
                sscanf(cmds[i], "%*63s %d", &ms);
                sleep_ms(ms);
            } else if (!strcmp(verb, "key") || !strcmp(verb, "down") || !strcmp(verb, "up")) {
                int code = -1;
                if (sscanf(cmds[i], "%*63s %63s", a0) == 1) code = key_code(a0);
                if (code < 0 || fds[0] < 0) { fprintf(stderr, "[rt-uinput] bad key on line %d\n", i); rc = 2; break; }
                if (strcmp(verb, "up") != 0) { emit(fds[0], EV_KEY, code, 1); syn(fds[0]); }
                if (strcmp(verb, "down") != 0) {
                    sleep_ms(40);
                    emit(fds[0], EV_KEY, code, 0);
                    syn(fds[0]);
                }
            } else if (!strcmp(verb, "mv") || !strcmp(verb, "click")) {
                int x = 0, y = 0;
                if (sscanf(cmds[i], "%*63s %d %d", &x, &y) != 2 || fds[1] < 0) { rc = 2; break; }
                abs_motion(fds[1], x, y);
                if (!strcmp(verb, "click")) {
                    sleep_ms(60);
                    emit(fds[1], EV_KEY, BTN_STYLUS, 1);
                    syn(fds[1]);
                    sleep_ms(120);
                    emit(fds[1], EV_KEY, BTN_STYLUS, 0);
                    syn(fds[1]);
                }
            } else if (!strcmp(verb, "tap") || !strcmp(verb, "drag")) {
                int x1 = 0, y1 = 0, x2 = 0, y2 = 0, steps = 12;
                int have = sscanf(cmds[i], "%*63s %d %d %d %d %d", &x1, &y1, &x2, &y2, &steps);
                if (fds[2] < 0) { rc = 2; break; }
                if (!strcmp(verb, "tap")) { x2 = x1; y2 = y1; }
                if (have < 2) { rc = 2; break; }
                emit(fds[2], EV_KEY, BTN_TOOL_FINGER, 1);
                abs_motion(fds[2], x1, y1);
                sleep_ms(30);
                emit(fds[2], EV_KEY, BTN_TOUCH, 1);
                syn(fds[2]);
                for (int s = 1; s <= steps; s++) {
                    double t = (double)s / (double)steps;
                    abs_motion(fds[2], (int)(x1 + (x2 - x1) * t), (int)(y1 + (y2 - y1) * t));
                    sleep_ms(30);
                }
                sleep_ms(80);
                emit(fds[2], EV_KEY, BTN_TOUCH, 0);
                emit(fds[2], EV_KEY, BTN_TOOL_FINGER, 0);
                syn(fds[2]);
            } else if (!strcmp(verb, "mtap")) {
                int x = 0, y = 0;
                if (sscanf(cmds[i], "%*63s %d %d", &x, &y) != 2 || fds[2] < 0) { rc = 2; break; }
                emit(fds[2], EV_ABS, ABS_MT_SLOT, 0);
                emit(fds[2], EV_ABS, ABS_MT_TRACKING_ID, 100);
                emit(fds[2], EV_ABS, ABS_MT_POSITION_X, x);
                emit(fds[2], EV_ABS, ABS_MT_POSITION_Y, y);
                emit(fds[2], EV_KEY, BTN_TOOL_DOUBLETAP, 1);
                emit(fds[2], EV_KEY, BTN_TOUCH, 1);
                syn(fds[2]);
                sleep_ms(150);
                emit(fds[2], EV_ABS, ABS_MT_TRACKING_ID, -1);
                emit(fds[2], EV_KEY, BTN_TOUCH, 0);
                emit(fds[2], EV_KEY, BTN_TOOL_DOUBLETAP, 0);
                syn(fds[2]);
            } else if (!strcmp(verb, "rmove") || !strcmp(verb, "rclick")) {
                int dx = 0, dy = 0;
                if (sscanf(cmds[i], "%*63s %d %d", &dx, &dy) != 2 || fds[3] < 0) { rc = 2; break; }
                emit(fds[3], EV_REL, REL_X, dx);
                emit(fds[3], EV_REL, REL_Y, dy);
                syn(fds[3]);
                if (!strcmp(verb, "rclick")) {
                    sleep_ms(60);
                    emit(fds[3], EV_KEY, BTN_LEFT, 1);
                    syn(fds[3]);
                    sleep_ms(140);
                    emit(fds[3], EV_KEY, BTN_LEFT, 0);
                    syn(fds[3]);
                }
            } else {
                fprintf(stderr, "[rt-uinput] unknown verb on line %d: %s\n", i, verb);
                rc = 2;
            }
        }
    }

    for (int slot = 0; slot < 4; slot++) {
        int f = fds[slot];
        if (f < 0) continue;
        destroy_dev(f);
        close(f);
    }
    printf("[rt-uinput] done rc=%d devices=%d\n", rc, ncreated);
    fflush(stdout);
    return rc;
}
