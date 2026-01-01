#ifndef FREEBOARD_H
#define FREEBOARD_H


// the purpose of this library is to make the most barebones version of something like libuiohook to guarantee cross platform compatibility,
// ensuring minimum features needed for things like launchers that need to listen to global events

#define FREEBOARD_KEY_DOWN 0
#define FREEBOARD_KEY_UP 1

typedef struct {
    int keycode;
    char keystring[2];
    int type;
} freehook_event;

int init_freeboard(void (*callback)(freehook_event *));
int start_freeboard_hook();

#endif // FREEBOARD_H

