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
- (void)loadData;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(!self.rounds) {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [self.refreshControl beginRefreshing];
    
    [PRRound allWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
        if(!error) {
            self.rounds = mappingResult.array;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error while fetching collection"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            
            [alertView show];
        }
        
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark - Actions

- (IBAction)refreshControlDidChangeValue:(UIRefreshControl *)control {
    [self loadData];
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
