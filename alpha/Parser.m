//
//  Parser.m
//  alpha
//
//  Created by Song, Yang on 2/17/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "Parser.h"
#import "Song.h"
@interface Parser()
@property(strong, nonatomic) NSMutableString *element;
@end

@implementation Parser
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //TODO: This is only compatiable for ios8 and later, add backward compatability
    if([elementName containsString:@"error"]) {
        if(_errors == nil) {
            _errors = [[NSMutableArray alloc]init];
        }
        Error *error = [[Error alloc]init];
        error.code = [attributeDict[@"code"] integerValue];
        _errors[0] = error;
    }
    if([elementName containsString:@"song"]) {
        if(_songs == nil) {
            _songs = [[NSMutableArray alloc]init];
        }
        Song *song = [[Song alloc]init];
        song.id = [attributeDict[@"id"] integerValue];
        [_songs addObject:song];
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
    if([elementName isEqualToString:@"auth"]) {
        if(_apiKey == nil) {
            _apiKey = [_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ];
        }
        
    } else if([elementName isEqualToString:@"session_expire"]) {
        if(_sessionExpire != nil) return;
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingAllTypes error:nil];
        NSString *timeStr = [self formatDateStr:_element];
        
        [detector enumerateMatchesInString:timeStr
                                   options:kNilOptions
                                     range:NSMakeRange(0, [timeStr length])
                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
        { _sessionExpire = result.date; }];
        
    } else if([elementName isEqualToString:@"error"]) {
        if(_errors != nil && [_errors count] != 0) {
            Error *error = [_errors lastObject];
            error.message = [_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [_errors replaceObjectAtIndex:[_errors count]-1 withObject:error];
        }
        
    } else if([elementName isEqualToString:@"title"]) {
        if(_songs != nil && [_songs count] != 0) {
            Song *song = [_songs lastObject];
            song.name = [_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [_songs replaceObjectAtIndex:[_songs count]-1 withObject:song];
        }
    } else if([elementName isEqualToString:@"artist"]) {
        if(_songs != nil && [_songs count] != 0) {
            Song *song = [_songs lastObject];
            song.artist = [_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [_songs replaceObjectAtIndex:[_songs count]-1 withObject:song];
        }
    } else if([elementName isEqualToString:@"album"]) {
        if(_songs != nil && [_songs count] != 0) {
            Song *song = [_songs lastObject];
            Album *album = [[Album alloc]init];
            album.name = [_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            song.album = album;
            [_songs replaceObjectAtIndex:[_songs count]-1 withObject:song];
        }
    } else if([elementName isEqualToString:@"time"]) {
        if(_songs != nil && [_songs count] != 0) {
            Song *song = [_songs lastObject];
            song.lengthInSeconds = [[_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] integerValue];
            [_songs replaceObjectAtIndex:[_songs count]-1 withObject:song];
        }
    } else if([elementName isEqualToString:@"url"]) {
        if(_songs != nil && [_songs count] != 0) {
            Song *song = [_songs lastObject];
            song.url = [_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [_songs replaceObjectAtIndex:[_songs count]-1 withObject:song];
        }
    } else if([elementName isEqualToString:@"art"]) {
        if(_songs != nil && [_songs count] != 0) {
            Song *song = [_songs lastObject];
            song.album.cover = [_element stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [_songs replaceObjectAtIndex:[_songs count]-1 withObject:song];
        }
    }
    _element = nil;
}

//TODO: use pointer
-(NSString *)formatDateStr:(NSString *)dateStr {
    NSMutableString *dateFormatedStr = [[NSMutableString alloc] init];
    NSArray *array = [dateStr componentsSeparatedByString:@"T"];
    [dateFormatedStr appendString:[array objectAtIndex:0]];
    [dateFormatedStr appendString:@" T "];
    [dateFormatedStr appendString:[array objectAtIndex:1]];
    return [NSString stringWithString:dateFormatedStr];
}

@end
