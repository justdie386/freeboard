//
//  freeboard.m
//  app
//
//  Created by Justin Bouchard on 2025-12-30.
//

#include "../freeboard.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGEvent.h>

CGEventRef callback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    void (*handler)(freehook_event *) = refcon;
    UniCharCount maxStringLength = 1;
    UniCharCount actualStringLength;
    UniChar unicodeString[maxStringLength];
    
    CGEventKeyboardGetUnicodeString(event, maxStringLength, &actualStringLength, unicodeString);
    
    NSString *characterString = [NSString stringWithCharacters:unicodeString length:actualStringLength];
    
    freehook_event freehook_event;
    
    strcpy(freehook_event.keystring, [characterString UTF8String]);
    handler(&freehook_event);
    
    return event;
}

void init_freeboard(void)
{
    CFMachPortRef tap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown), callback, (void *)freehook_callback );
    CFRunLoopSourceRef source = CFMachPortCreateRunLoopSource(NULL, tap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    CGEventTapEnable(tap, true);
}

int start_freeboard_hook()
{
    CFRunLoopRun();
    return 0;
}
