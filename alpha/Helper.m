//
//  Helper.m
//  alpha
//
//  Created by Song, Yang on 2/11/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "Helper.h"

@interface Helper()

@end


@implementation Helper

+(NSMutableString *)concat: (NSString *)s1 and:(NSString *)s2 {
    NSMutableString *result = [NSMutableString stringWithString:[s1 stringByAppendingString:s2]];
    return result;
}

+(NSString *)getTimeStrWithSeconds: (NSInteger) seconds {
    NSInteger hh = seconds / 3600;
    NSInteger mm = (seconds / 60) % 60;
    NSInteger ss = seconds % 60;
    NSMutableString *result = [[NSMutableString alloc]init];
    if(hh != 0) {
        [result appendFormat:@"%02ld:", hh];
    }
    [result appendFormat:@"%02ld:%02ld", mm, ss];
    return result;
}

@end
