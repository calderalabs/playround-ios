//
//  PRFeedViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 4/15/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRFeedViewController.h"
#import "PRFeedTableViewCell.h"
#import "PRRound.h"
#import "PRRoundViewController.h"

@implementation PRFeedViewController

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
    UITableViewCell *cell = sender;
    
    if([segue.identifier isEqualToString:@"Play"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        PRPlayViewController *playViewController = (PRPlayViewController *)navigationController.visibleViewController;
        playViewController.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"Show"]) {
        PRRoundViewController *roundViewController = (PRRoundViewController *)segue.destinationViewController;
        PRRound *round = self.collection[[self.tableView indexPathForCell:cell].row];
        roundViewController.round = round;
    }
}

- (void)playViewControllerDidCreateRound:(PRPlayViewController *)playViewController {
    [self fetchCollection];
}

@end
