//
//  main.c
//  
//
//  Created by Justin Bouchard on 2025-12-29.
//

#include <stdio.h>
#include "freeboard.h"


int key_down = -1;

void freehook_callback(freehook_event *event)
{
    
    switch (event->type)
    {
        case FREEBOARD_KEY_DOWN:
            if (key_down != -1 && event->keycode != key_down)
            {
                printf("Two keys pressed at once!\nkey 1: %d\nkey 2: %d", key_down, event->keycode);
            }
            
            key_down = event->keycode;
            break;
            
        case FREEBOARD_KEY_UP:
            
            printf("key pressed (keycode): %d\n", event->keycode);
            printf("key pressed (letter): %s\n", event->keystring);
            
            if (event->keycode == key_down)
            {
                key_down = -1;
            }
            break;
    }
}

int main()
{
    if (init_freeboard(freehook_callback) != 0) {
        printf("Failed to initialize freehook\n");
    } else {
        printf("Freehook initialized!\n");
    }
    start_freeboard_hook();
}
