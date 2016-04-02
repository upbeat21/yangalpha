//
//  SongListViewController.m
//  alpha
//
//  Created by Song, Yang on 2/23/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "SongListViewController.h"
#import "SongTableViewCell.h"
#import "AmpacheFactory.h"
#import "Song.h"
#import "SongTableView.h"
#import "SongTableViewCell.h"
#import "PlayerViewController.h"
#import "Artist.h"
#import "AppDelegate.h"

@interface SongListViewController()
@property (strong, nonatomic) AmpacheFactory *service;
@property (strong, nonatomic) Song *selectedSong;
@property (assign, nonatomic) NSInteger selectedSongNum;
//@property (weak, nonatomic) IBOutlet SongTableView *songTableView;



@end
@implementation SongListViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.service = [AmpacheFactory sharedFactory];
    if(self.songs == nil && self.artist == nil) {
        self.songs = [self.service getSongs];
    } else if(self.artist != nil) {
        self.songs = [self.service getSongByArtistId:self.artist.id];
    }
    [self viewSetUP];
}

- (void)viewSetUP {
    UIImage *playingButtonImage = [UIImage imageNamed:@"playing"];
    /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:playingButtonImage forState:UIControlStateNormal];
    self.playingButton = [[UIBarButtonItem alloc] initWithCustomView:button];*/
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:playingButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(showPlaying:)];
    //self.navigationItem.rightBarButtonItem
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //Return the number of sections.
    return [self.songs count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songCell" forIndexPath:indexPath];
    Song *song = [self.songs objectAtIndex:indexPath.section];
    cell.titleLabel.text = song.name;
    cell.artistLabel.text = song.artist;
    cell.lengthLabel.text = song.length;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSong = [self.songs objectAtIndex:indexPath.section];
    self.selectedSongNum = indexPath.section;
    [self performSegueWithIdentifier:@"playerViewSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PlayerViewController *pvc = [segue destinationViewController];
    pvc.songs = self.songs;
    pvc.song = self.selectedSong;
    pvc.num = self.selectedSongNum;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.pvc stop];
    [app.pvc removePlayerObserver];
    app.pvc = nil;
    
}
- (IBAction)showPlaying:(id)sender {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:app.pvc animated:YES];
}


@end
