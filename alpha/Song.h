//
//  Song.h
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Album.h"

@interface Song : NSObject
@property(assign, nonatomic) NSInteger id;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *artist;
@property(strong, nonatomic) Album *album;
@property(strong, nonatomic) NSString *tag;
@property(strong, nonatomic) NSString *filename;
@property(strong, nonatomic) NSString *url;
@property(strong, nonatomic) NSString *length;
@property(assign, nonatomic) NSInteger lengthInSeconds;
@end
