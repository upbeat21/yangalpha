//
//  PlayerViewController.m
//  alpha
//
//  Created by Song, Yang on 2/25/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "PlayerViewController.h"
#import "Helper.h"
#import "SongListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
@import AVFoundation;


@interface PlayerViewController()
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (assign, nonatomic) BOOL isMusicLoaded;
@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger seconds;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) UIImage *playImage;
@property (strong, nonatomic) UIImage *pauseImage;
@property (strong, nonatomic) UIImage *defaultCover;

@end

@implementation PlayerViewController

static const NSString *ItemStatusContext;

-(void)viewDidLoad {
    MPNowPlayingInfoCenter *npic = [MPNowPlayingInfoCenter defaultCenter];
    NSLog(@"%@", [npic.nowPlayingInfo objectForKey:MPMediaItemPropertyTitle]);
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    [self initiate];
}

-(void)initiate {
    self.startLabel.text = [Helper getTimeStrWithSeconds:self.seconds];
    self.lengthLabel.text = self.song.length;
    self.progressSlider.value = 0.0;
    self.seconds = 0;
    self.title = self.song.name;
    self.coverImage.image = self.defaultCover;
    
    [self addObserver:self forKeyPath:@"seconds" options:0 context:nil];
    [self loadImage];
    [self loadMusic];
    
    [self addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionInitial context:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.pvc = self;
    [super viewWillDisappear:animated];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if(event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self.player play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self.player pause];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self togglePlayPause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self forward:self];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self rewind:self];
                break;
            default:
                break;
        }
    }
}

//This method needs to be called after image is loaded
- (void)setPlayingInfo {
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if(playingInfoCenter) {
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc]init];
        [songInfo setObject:self.song.name forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:self.song.album.name forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:self.song.artist forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:[NSNumber numberWithInt:1] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc]initWithImage:self.coverImage.image];
        [songInfo setObject:artWork forKey:MPMediaItemPropertyArtwork];
        artWork = nil;
        
        MPNowPlayingInfoCenter *npic = [MPNowPlayingInfoCenter defaultCenter];
        npic.nowPlayingInfo = songInfo;
    }
    
}

-(void)initTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(proceed) userInfo:nil repeats:YES];
}

-(void)proceed {
    self.seconds = CMTimeGetSeconds(self.player.currentTime);
    [self.progressSlider setValue:self.seconds animated:YES];
}



-(void)loadImage {
    //load button image;
    self.playImage = [UIImage imageNamed:@"play"];
    self.pauseImage = [UIImage imageNamed:@"pause"];
    //load albumn cover
    NSURL *imageUrl = [NSURL URLWithString:self.song.album.cover];
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_async(queue, ^(void) {
        __block NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        __block UIImage *coverImage = [[UIImage alloc]initWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(coverImage != nil) {
                self.coverImage.image = coverImage;
                [self setPlayingInfo];
            }
        });
    });
}

-(void)loadMusic {
    NSURL *musicURL = [NSURL URLWithString:self.song.url];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
    NSString *tracksKey = @"tracks";
    [asset loadValuesAsynchronouslyForKeys:@[tracksKey] completionHandler:^{

        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
            if(status == AVKeyValueStatusLoaded) {
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                //Ensure this is done before associate the playeritem to the player
                [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial context:&ItemStatusContext];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification
                                                           object:nil];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
            } else {
                //Error Handling
                NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
            }
        });
    }];
}

- (void)removePlayerObserver {
    [self removeObserver:self forKeyPath:@"seconds"];
    [self removeObserver:self forKeyPath:@"isPlaying"];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}


-(void) addPlayingInfo {
    
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if(context == &ItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
        //This is the time when the status property got populated, can sync ui
            [self syncUI];
        });
        return;
    } else if([keyPath isEqualToString:@"seconds"]){
        self.startLabel.text = [Helper getTimeStrWithSeconds:self.seconds];
    } else if([keyPath isEqualToString:@"isPlaying"]) {
        if(self.isPlaying) {
            [self.playPauseButton setImage:self.pauseImage forState:UIControlStateNormal];


        } else {
            [self.playPauseButton setImage:self.playImage forState:UIControlStateNormal];
        }
    }
    //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    return;
}

-(void)syncUI {
    if(self.player.currentItem != nil && [self.player.currentItem status] == AVPlayerItemStatusReadyToPlay) {
        self.isMusicLoaded = YES;
        self.progressSlider.maximumValue = CMTimeGetSeconds(self.player.currentItem.asset.duration);
        [self initTimer];
        [self.player play];
        self.isPlaying = YES;
        
    } else {
        self.isMusicLoaded = NO;
    }
}

-(void)playerItemDidReachEnd: (NSNotificationCenter *)notification {
    //Set the player to the begining when receive notification of player item reach end
    [self forward:self];
}


-(void)togglePlayPause {
    if(self.isPlaying) {
        [self.player pause];
        self.isPlaying = NO;
        [self.timer invalidate];
        
    } else {
        [self.player play];
        self.isPlaying = YES;
        [self initTimer];
    }
}

- (IBAction)playPause:(id)sender {
    [self togglePlayPause];
}
- (IBAction)forward:(id)sender {
    if(self.num == [self.songs count]-1) {
        return;
    }
    self.num++;
    self.song = [self.songs objectAtIndex:self.num];
    [self removePlayerObserver];
    [self initiate];
}
- (IBAction)rewind:(id)sender {
    if(self.num == 0) {
        return;
    }
    self.num--;
    self.song = [self.songs objectAtIndex:self.num];
    [self removePlayerObserver];
    [self initiate];
}

- (void)stop {
    [self.player pause];
}

- (IBAction)progressChanged:(id)sender {
    self.seconds = self.progressSlider.value;
    [self.player seekToTime:CMTimeMake(self.seconds, 1)];
}

- (void) didReceiveMemoryWarning {
    NSLog(@"MEMORY WARNING!");
    [super didReceiveMemoryWarning];
}



@end
