//
//  Parser.h
//  alpha
//
//  Created by Song, Yang on 2/17/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"

@interface Parser : NSObject<NSXMLParserDelegate>
@property(strong, nonatomic) NSString *apiKey;
@property(strong, nonatomic) __block NSDate *sessionExpire;
@property(strong, nonatomic) NSMutableArray *errors;
@property(strong, nonatomic) NSMutableArray *songs;
@property(strong, nonatomic) NSMutableArray *albums;
@property(strong, nonatomic) NSMutableArray *artists;

@end
