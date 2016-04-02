//
//  Error.h
//  alpha
//
//  Created by Song, Yang on 2/18/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject
@property(assign, nonatomic) NSInteger code;
@property(strong, nonatomic) NSString *message;
@end
