//
//  SongTableViewCell.h
//  alpha
//
//  Created by Song, Yang on 2/23/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;

@end
