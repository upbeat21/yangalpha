//
//  ArtistViewController.m
//  alpha
//
//  Created by Song, Yang on 3/8/16.
//  Copyright © 2016 Song, Yang. All rights reserved.
//

#import "ArtistViewController.h"
#import "AmpacheFactory.h"
#import "Artist.h"
#import "ArtistTableViewCell.h"
#import "SongListViewController.h"
#import "ArtistTableView.h"

@interface ArtistViewController()

@property (strong, nonatomic) NSMutableArray *artists;
@property (strong, nonatomic) AmpacheFactory *service;
@property (strong, nonatomic) Artist *selectedArtist;
@property (weak, nonatomic) IBOutlet ArtistTableView *artistTableView;

@end

@implementation ArtistViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.service = [AmpacheFactory sharedFactory];
    self.artists = [self.service getArtists];
    self.artistTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.artistTableView.separatorColor = [UIColor grayColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //Return the number of sections.
    return [self.artists count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistCell" forIndexPath:indexPath];
    Artist *artist = [self.artists objectAtIndex:indexPath.section];
    cell.artistLabel.text = artist.name;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedArtist = [self.artists objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:@"artistSongSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SongListViewController *svc = [segue destinationViewController];
    svc.artist = self.selectedArtist;
}


@end
