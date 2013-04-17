//
//  PRFeedTableViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 4/15/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRFeedTableViewController.h"
#import "PRFeedTableViewCell.h"
#import "PRRound.h"

@interface PRFeedTableViewController ()

@property (nonatomic, strong) NSArray *rounds;

- (IBAction)refreshControlDidChangeValue:(UIRefreshControl *)control;

@end

@implementation PRFeedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlDidChangeValue:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)refreshControlDidChangeValue:(UIRefreshControl *)control {
    PRRound *round = [[PRRound alloc] init];
    PRUser *user = [[PRUser alloc] init];
    PRArena *arena = [[PRArena alloc] init];
    PRGame *game = [[PRGame alloc] init];
    
    user.name = @"Eugenio Depalo";
    user.pictureURL = [NSURL URLWithString:@"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash3/c32.9.117.117/s100x100/526570_371377206303965_1223495359_a.jpg"];
    arena.name = @"DotA Bar";
    game.pictureURL = [NSURL URLWithString:@"http://www.dota2wiki.com/images/thumb/7/76/Dota_2_logo.png/41px-Dota_2_logo.png"];
    round.status = @"ongoing";
    round.createdAt = [NSDate date];
    round.user = user;
    round.arena = arena;
    round.game = game;
    
    self.rounds = @[round];
    
    [self.tableView reloadData];
    [control endRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Feed";
    
    PRFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PRRound *round = self.rounds[indexPath.row];
    
    cell.statusLabel.text = round.status.uppercaseString;
    cell.usernameLabel.text = round.user.name;
    cell.dateLabel.text = round.createdAt.description;
    cell.arenaLabel.text = round.arena.name;
    [cell.userPictureImageView setImageWithURL:round.user.pictureURL];
    [cell.gameImageView setImageWithURL:round.game.pictureURL];
    
    return cell;
}

@end
