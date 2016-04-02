//
//  SongListViewController.h
//  alpha
//
//  Created by Song, Yang on 2/23/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"
#import "PlayerViewController.h"

@interface SongListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) Artist *artist;
@property (strong, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) PlayerViewController *pvc;

@end
