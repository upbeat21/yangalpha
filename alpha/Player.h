//
//  Player.h
//  alpha
//
//  Created by Song, Yang on 2/25/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Player <NSObject>

-(void)setPlayerWithURL: (NSURL *)url;
-(void)Play;
-(void)PlaySelectedSongURL: (NSURL *)url;

@end
