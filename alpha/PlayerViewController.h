//
//  PlayerViewController.h
//  alpha
//
//  Created by Song, Yang on 2/25/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface PlayerViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) Song *song;
@property (assign, nonatomic) NSInteger num;

-(void)stop;
-(void)removePlayerObserver;

@end
