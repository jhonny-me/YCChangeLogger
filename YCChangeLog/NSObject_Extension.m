//
//  NSObject_Extension.m
//  YCChangeLog
//
//  Created by 顾强 on 16/1/12.
//  Copyright © 2016年 jhonny.copper. All rights reserved.
//


#import "NSObject_Extension.h"
#import "YCChangeLog.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[YCChangeLog alloc] initWithBundle:plugin];
        });
    }
}
@end
