//
//  YCChangeLog.m
//  YCChangeLog
//
//  Created by 顾强 on 16/1/12.
//  Copyright © 2016年 jhonny.copper. All rights reserved.
//

#import "YCChangeLog.h"
#import "DTXcodeUtils.h"
#import "DTXcodeHeaders.h"
#import "VVTextResult.h"
#import "YCLogManager.h"
#import "XcodePrivate.h"
#import "NSTextView+VVTextGetter.h"

@interface YCChangeLog()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@property (nonatomic, assign) BOOL hasPrefixTyped;
@end

@implementation YCChangeLog

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeTextDidChanged:) name:NSTextDidChangeNotification object:nil];
        
        self.hasPrefixTyped = NO;
    }
    //
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        // Set ⌃⌘X as our plugin's keyboard shortcut.
        [actionMenuItem setKeyEquivalent:@"x"];
        [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask | NSCommandKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

// Sample Action, for menu item:
- (void)doMenuAction
{
    // This is a reference to the current source code editor.
    DVTSourceTextView *sourceTextView = [DTXcodeUtils currentSourceTextView];
    // Get the range of the selected text within the source code editor.
    NSRange selectedTextRange = [sourceTextView selectedRange];
    // Get the selected text using the range from above.
    NSString *selectedString = [sourceTextView.textStorage.string substringWithRange:selectedTextRange];
    if (selectedString) {
        // Replace the selected string with a comment.
        [sourceTextView replaceCharactersInRange:selectedTextRange withString:@"// Malkovich Malkovich Malkovich"];
    }
}

- (void)storeTextDidChanged:(NSNotification *)noti{

    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        
        NSTextView *textView = (NSTextView *)[noti object];
        
        VVTextResult *currentLineResult = [textView vv_textResultOfCurrentLine];

        if (currentLineResult) {

            NSString* stringWithoutBlanks = [currentLineResult.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if ([stringWithoutBlanks isEqualToString:@"//\\"]) {
                
                DVTSourceTextStorage *textStorage = (DVTSourceTextStorage *)textView.textStorage;
                
                [textStorage replaceCharactersInRange:currentLineResult.range withString:[YCLogManager defaultLog] withUndoManager:[textView undoManager]];
                
//                [textView replaceCharactersInRange:NSMakeRange(currentLineResult.range.location + currentLineResult.range.length -3, 3) withString:[YCLogManager defaultLog] ];
//                [textView undoManager];
                
                //Set cursor before the inserted documentation. So we can use tab to begin edit.

                [textView setSelectedRange:NSMakeRange(currentLineResult.range.location, 0)];
                
                //Send a 'tab' after insert the doc. For our lazy programmers. :)
                [self sendTabEvent];
            }
        }
    }
}



-(void) sendTabEvent
{
    CGEventSourceRef src = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    //kVK_Tab = 0x30, See http://forums.macrumors.com/archive/index.php/t-1216916.html
    CGEventRef tab = CGEventCreateKeyboardEvent(src, 0x30, true);
    CGEventTapLocation loc = kCGHIDEventTap;
    CGEventPost(loc, tab);
    CFRelease(tab);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
