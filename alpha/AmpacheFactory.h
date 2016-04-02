//
//  AmpacheFactory.h
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@interface AmpacheFactory : NSObject
@property(strong, nonatomic) Session *session;

+(instancetype)sharedFactory;
-(BOOL)handShake;
-(NSMutableArray *)getSongs;
-(NSMutableArray *)getAlbumByArtistId: (NSInteger)id;
-(NSMutableArray *)getSongByArtistId:(NSInteger) id;
-(NSMutableArray *)getArtists;
@end
