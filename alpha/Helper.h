//
//  Helper.h
//  alpha
//
//  Created by Song, Yang on 2/11/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+(NSMutableString *)concat:(NSString *)s1 and:(NSString *)s2;
+(NSString *)getTimeStrWithSeconds: (NSInteger) seconds;
@end
