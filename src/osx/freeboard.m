//
//  freeboard.m
//  app
//
//  Created by Justin Bouchard on 2025-12-30.
//

#import "../freeboard.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGEvent.h>

#import "../freeboard.h"
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

CGEventRef event_tap_callback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    if (!refcon) return event;
    
    void (*user_callback)(freehook_event *) = refcon;
    
    UniCharCount maxLength = 1;
    UniCharCount actualLength;
    UniChar buffer[maxLength];
    int current_key;
    CGEventKeyboardGetUnicodeString(event, maxLength, &actualLength, buffer);
    
    freehook_event fh_event = {0};
    strncpy(fh_event.keystring, [[NSString stringWithCharacters:buffer length:actualLength] UTF8String], sizeof(fh_event.keystring)-1);
    current_key = CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    fh_event.keycode = current_key;
    switch (type)
    {
        case kCGEventKeyDown:
            fh_event.type = 0;
            break;
            
        case kCGEventKeyUp:
            fh_event.type = 1;
            break;
            
        default:
            
            break;
    }
    
    user_callback(&fh_event);

    return event;
}

int init_freeboard(void (*callback)(freehook_event *))
{
    
    CGEventMask mask =
        CGEventMaskBit(kCGEventKeyDown) |
        CGEventMaskBit(kCGEventKeyUp);
    
    CFMachPortRef tap = CGEventTapCreate(
        kCGHIDEventTap,
        kCGHeadInsertEventTap,
        kCGEventTapOptionDefault,
        mask,
        event_tap_callback,
        callback
    );

    if (!tap) {
        NSLog(@"Failed to create event tap");
        return 1;
    }

    CFRunLoopSourceRef source = CFMachPortCreateRunLoopSource(NULL, tap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    CGEventTapEnable(tap, true);
    return 0;
}

int start_freeboard_hook()
{
    CFRunLoopRun();
    return 0;
}
