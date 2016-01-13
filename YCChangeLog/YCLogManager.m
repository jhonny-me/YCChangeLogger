//
//  YCLogManager.m
//  YCChangeLog
//
//  Created by 顾强 on 16/1/13.
//  Copyright © 2016年 jhonny.copper. All rights reserved.
//

#import "YCLogManager.h"

@implementation YCLogManager

+ (NSString *)defaultLog{
    // get author name
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString* name = [environment objectForKey:@"LOGNAME"];
    
    name = name.length > 0 ? name:@"YCode";
    
    return [NSString stringWithFormat:@"/*\n%@%@ *\n%@ */\n",[self nameLine],[self timeLine],[self descriptionLine]];
}

+ (NSString *)nameLine{
    
    return [NSString stringWithFormat:@" * Add by %@\n",[self authorName]];
}

+ (NSString *)timeLine{
    
    return [NSString stringWithFormat:@" * Time   %@\n",[self currentTimeString]];
}

+ (NSString *)descriptionLine{
    
    return [NSString stringWithFormat:@" * Description <#description#>\n"];
}
+ (NSString *)authorName{
    // get author name
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString* name = [environment objectForKey:@"LOGNAME"];
    
    return name.length > 0 ? name:@"YCode";
}

+ (NSString *)currentTimeString{
    // get current time string
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = ({
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        dateFormatter;
    });
    
    return [formatter stringFromDate:currentDate];
}
@end
