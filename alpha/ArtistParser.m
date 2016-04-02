//
//  ArtistParser.m
//  alpha
//
//  Created by Song, Yang on 3/8/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "ArtistParser.h"
#import "Artist.h"

@interface ArtistParser()
@property (strong, nonatomic) NSMutableString *element;
@end
@implementation ArtistParser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //TODO: This is only compatiable for ios8 and later, add backward compatability

    if([elementName containsString:@"artist"]) {
        if(self.artists == nil) {
            self.artists = [[NSMutableArray alloc]init];
        }
        Artist *artist = [[Artist alloc]init];
        artist.id = [attributeDict[@"id"] integerValue];
        [self.artists addObject:artist];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(!_element) {
        _element = [[NSMutableString alloc] initWithString:string];
    } else {
        [_element appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"name"]) {
        if(self.artists != nil && [self.artists count] != 0) {
            Artist *artist = [self.artists lastObject];
            artist.name = [_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.artists replaceObjectAtIndex:[self.artists count]-1 withObject:artist];
        }
    } else if([elementName isEqualToString:@"songs"]) {
        if(self.artists != nil && [self.artists count] != 0) {
            Artist *artist = [self.artists lastObject];
            artist.songNums = [[_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]integerValue];
            [self.artists replaceObjectAtIndex:[self.artists count]-1 withObject:artist];
        }
    }
    _element = nil;
}
@end
