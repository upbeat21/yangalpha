//
//  User.h
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UserType) {
    Guest,
    L1User,
    Admin
};

@interface User : NSObject
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *password;

+(instancetype)sharedUser;


@end
