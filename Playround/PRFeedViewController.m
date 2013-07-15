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
#import "PRPlayViewController.h"

@implementation PRFeedViewController

- (Class)collectionClass {
    return [PRRound class];
}

- (void)setupCell:(PRFeedTableViewCell *)cell model:(PRRound *)round {
    cell.statusLabel.text = round.stateDisplayName;
    cell.usernameLabel.text = round.user.name;
    
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    cell.dateLabel.text = [timeIntervalFormatter stringForTimeInterval:[round.createdAt timeIntervalSinceNow]];

    if(round.game.pictureURL)
        [cell.gameImageView setImageWithURL:round.game.pictureURL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *cell = sender;
    
    if([segue.identifier isEqualToString:@"Show"]) {
        PRRoundViewController *roundViewController = (PRRoundViewController *)segue.destinationViewController;
        PRRound *round = self.collection[[self.tableView indexPathForCell:cell].row];
        roundViewController.round = round;
    }
}

@end
