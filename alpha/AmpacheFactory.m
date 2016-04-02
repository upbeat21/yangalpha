//
//  AmpacheFactory.m
//  alpha
//
//  Created by Song, Yang on 2/10/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "AmpacheFactory.h"
#import <CommonCrypto/CommonDigest.h>
#import "Helper.h"
#import "Parser.h"
#import "ArtistParser.h"
#import "Song.h"

@interface AmpacheFactory() 

@property(strong, nonatomic) NSString *apiKey;
@property(strong, nonatomic) NSString *host;
@property(strong, nonatomic) NSString *direcotry;
@property(strong, nonatomic) NSMutableArray *songs;

@end

@implementation AmpacheFactory

static NSInteger const numberLimit = 50;

+(instancetype)sharedFactory {
    static AmpacheFactory *sharedFactory;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedFactory = [[AmpacheFactory alloc] init];
    });
    return sharedFactory;
}

-(id)init {
    if(self = [super init]) {
        _session = [Session sharedSession];
        _songs = [[NSMutableArray alloc]init];
        //_host = @"http://73.241.242.70:8080";
        self.host = @"http://yangalpha-musichub.rhcloud.com";
        //self.host = @"192.168.31.132";
        self.direcotry = @"/server/xml.server.php?";
    }
    return self;
}

-(NSString *)getURL {
    return [NSString stringWithString:[Helper concat:_host and:_direcotry]];
}

-(BOOL)handShake {
    NSString *urlStr = [self getHandShakeStr];
    NSLog(@"The passphrase is %@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    /*NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    __block NSData *xmldata = nil;
    __block NSURLResponse *response = nil;
    __block NSError *error = nil;
    [request setHTTPMethod:@"GET"];
    [request setURL:url];
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        response = res;
        xmldata = data;
        error = err;
    }];
    NSString *xmlStr = [[NSString alloc]initWithData:xmldata encoding:NSUTF8StringEncoding];*/
    //NSLog(@"The response is %@", xmlStr);
    Parser *delegate = [self handleResponseWithURL:url];
    if(delegate.errors != nil && [delegate.errors count] != 0) {
        return NO;
    } else {
        if(delegate.apiKey == nil) {
            return NO;
        } else {
            self.apiKey = delegate.apiKey;
        }
        if(delegate.sessionExpire == nil) {
            return NO;
        } else {
            self.session.sessionExpire = delegate.sessionExpire;
        }
    }
    return YES;
}

-(void)getSongsWithFilter: (NSString *)filter {
    
}

//Need to measure the time to decide if should use synchronized call
-(NSMutableArray *)getSongs {
    if(!_apiKey) {
        if(![self handShake]) return nil;
    }
    NSMutableString *command = [NSMutableString stringWithString:@"action=songs&auth="];
    [command appendString:_apiKey];
    NSURL *url = [self getURLWithCommand:command];
    NSLog(@"The getSongs url is %@", url);
    Parser *delegate = [self handleResponseWithURL:url];
    for(Song *song in delegate.songs) {
        [self setLengthStr:song];
    }
    return delegate.songs;
}

-(NSMutableArray *)getArtists {
    if(!self.apiKey) {
        if(![self handShake]) return nil;
    }
    NSMutableString *command = [NSMutableString stringWithString:@"action=artists&auth="];
    [command appendString:self.apiKey];
    NSURL *url = [self getURLWithCommand:command];
    ArtistParser *delegate = [self handleArtistResponseWithURL:url];
    return delegate.artists;
}

-(void)setLengthStr:(Song *)song {
    song.length = [Helper getTimeStrWithSeconds:song.lengthInSeconds];
}

-(NSMutableArray *)getAlbumByArtistId:(NSInteger)id {
    if(!self.apiKey) {
        if(![self handShake]) return nil;
    }
    NSMutableString *command = [NSMutableString stringWithString:@"action=artist_albums&auth="];
    [command appendString:_apiKey];
    [command appendString:@"&filter="];
    [command appendString:[NSString stringWithFormat:@"%ld", (long)id]];
    NSURL *url = [self getURLWithCommand:command];
    Parser *delegate = [self handleResponseWithURL:url];
    return delegate.albums;
}

-(NSMutableArray *)getSongByArtistId:(NSInteger) id {
    if(!self.apiKey) {
        if(![self handShake]) return nil;
    }
    NSMutableString *command = [NSMutableString stringWithString:@"action=artist_songs&auth="];
    [command appendString:self.apiKey];
    [command appendString:@"&filter="];
    [command appendString:[NSString stringWithFormat:@"%ld", (long)id]];
    NSURL *url = [self getURLWithCommand:command];
    Parser *delegate = [self handleResponseWithURL:url];
    for(Song *song in delegate.songs) {
        [self setLengthStr:song];
    }
    return delegate.songs;
}

-(NSURL *)getURLWithCommand: (NSString *)command {
    NSString *urlStr1 = [Helper concat:_host and:_direcotry];
    NSString *urlStr2 = [Helper concat:urlStr1 and:command];
    return [NSURL URLWithString:urlStr2];
}


-(Parser *)handleResponseWithURL: (NSURL *)url {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    Parser *delegate = [[Parser alloc] init];
    [parser setDelegate: delegate];
    [parser parse];
    return delegate;
    
}

-(ArtistParser *)handleArtistResponseWithURL: (NSURL *)url {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    ArtistParser *delegate = [[ArtistParser alloc] init];
    [parser setDelegate: delegate];
    [parser parse];
    return delegate;
    
}


-(NSString *)getHandShakeStr {
    NSMutableString *command = [NSMutableString stringWithString:@"action=handshake&auth="];
    NSString *time = [self getLocalTimeStr];
    NSString *passphrase = [self generatePassPhraseWithTime:time];
    //NSString *passphrase = @"NS";
    NSString *username = _session.user.username;
    //TODO: change this
    command = [Helper concat:command and:passphrase];
    command = [Helper concat:command and:@"&timestamp="];
    command = [Helper concat:command and:time];
    command = [Helper concat:command and:@"&version=350001&user="];
    command = [Helper concat:command and:username];
    return [Helper concat:[self getURL] and:command];
}

-(NSString *)getLocalTimeStr {
    long date = [[NSDate date]timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", date];
}

//Take same time string from handshake to keep it consistent
-(NSString *)generatePassPhraseWithTime: (NSString *)timeStr {
    NSString *timeStampStr = [self getLocalTimeStr];
    NSString *key = [self sha256:_session.user.password];
    NSString *passphrase = [self sha256:[timeStampStr stringByAppendingString:key]];
    return passphrase;
}


-(NSString*) sha256:(NSString *)str{
    const char *s=[str cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}


@end
