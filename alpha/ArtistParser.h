//
//  ArtistParser.h
//  alpha
//
//  Created by Song, Yang on 3/8/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtistParser : NSObject<NSXMLParserDelegate>
@property (strong, nonatomic) NSMutableArray *artists;
@end
