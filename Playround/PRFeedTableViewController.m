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

@implementation PRFeedTableViewController

- (Class)collectionClass {
    return [PRRound class];
}

- (void)setupCell:(PRFeedTableViewCell *)cell model:(PRRound *)round {
    cell.statusLabel.text = round.state.uppercaseString;
    cell.usernameLabel.text = round.user.name;
    cell.dateLabel.text = round.createdAt.description;
    cell.arenaLabel.text = round.arena.name;
    
    if(round.user.pictureURL)
        [cell.userPictureImageView setImageWithURL:round.user.pictureURL];
    
    if(round.game.pictureURL)
        [cell.gameImageView setImageWithURL:round.game.pictureURL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Play"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PRPlayViewController *playViewController = (PRPlayViewController *)navigationController.visibleViewController;
        playViewController.delegate = self;
    }
}

- (void)playViewControllerDidCreateRound:(PRPlayViewController *)playViewController {
    [self fetchCollection];
}

@end
