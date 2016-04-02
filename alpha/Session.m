//
//  Session.m
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "Session.h"

@interface Session()

@end
@implementation Session

+(instancetype)sharedSession {
    static Session *session;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        session = [[self alloc]init];
    });
    return session;
}

-(id)init {
    if(self = [super init]) {
        _user = [User sharedUser];
        self.user.username = @"admin";
        self.user.password = @"Pa$$word!";
        _isGuest = YES;
    }
    return self;
}


-(BOOL)isGuest{
    return self.isGuest;
}

-(BOOL)isSessionExpire {
    NSDate *current = [NSDate date];
    if([current compare:self.sessionExpire] == NSOrderedDescending) {
        return YES;
    } else return NO;
}

@end
