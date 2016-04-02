//
//  Artist.m
//  alpha
//
//  Created by Song, Yang on 2/24/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "Artist.h"
#import "AmpacheFactory.h"

@interface Artist()

@end

@implementation Artist
@synthesize albums = _albums;

-(instancetype)initWithID:(NSInteger)id name:(NSString *)name {
    self = [super init];
    if(self) {
        self.id = id;
        self.name = name;
    }
    return self;
}

-(NSMutableArray *)albums {
    if(_albums == nil) {
        AmpacheFactory *service = [AmpacheFactory sharedFactory];
        _albums = [service getAlbumByArtistId:self.id];
    }
    return _albums;
}

@end
