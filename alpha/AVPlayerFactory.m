//
//  AVPlayerFactory.m
//  alpha
//
//  Created by Song, Yang on 3/15/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "AVPlayerFactory.h"

@implementation AVPlayerFactory

+(instancetype) sharedPlayer {
    static AVPlayerFactory *player;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        player = [[AVPlayerFactory alloc]init];
    });
    return player;
}

@end
