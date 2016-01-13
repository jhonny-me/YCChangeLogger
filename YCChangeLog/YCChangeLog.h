//
//  YCChangeLog.h
//  YCChangeLog
//
//  Created by 顾强 on 16/1/12.
//  Copyright © 2016年 jhonny.copper. All rights reserved.
//

#import <AppKit/AppKit.h>

@class YCChangeLog;

static YCChangeLog *sharedPlugin;

@interface YCChangeLog : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end