//
//  User.m
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "User.h"

@interface User()
@property(assign, nonatomic) UserType *userType;
@end

@implementation User

+(instancetype)sharedUser {
    static User *user;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        user = [[self alloc]init];
    });
    return user;
}

-(id)init {
    if(self = [super init]) {
        _username = @"Guest";
        _userType = Guest;
        _password = nil;
    }
    return self;
}

@end
