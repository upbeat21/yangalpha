//
//  Session.h
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Session : NSObject
@property(strong, nonatomic) User *user;
@property(strong, nonatomic) NSString *auth;
@property(assign, nonatomic) BOOL isGuest;
@property(strong, nonatomic) NSDate *sessionExpire;

+(instancetype)sharedSession;
-(BOOL)isGuest;
-(BOOL)isSessionExpire;
@end
