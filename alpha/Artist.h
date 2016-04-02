//
//  Artist.h
//  alpha
//
//  Created by Song, Yang on 2/24/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject
@property(assign, nonatomic) NSInteger id;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic, readonly) NSMutableArray *albums;
@property(assign, nonatomic) NSInteger songNums;

-(instancetype)initWithID:(NSInteger) id name:(NSString *) name;

@end
