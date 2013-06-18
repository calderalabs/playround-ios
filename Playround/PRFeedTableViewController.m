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

@end

@implementation PRFeedTableViewController

- (Class)collectionClass {
    return [PRRound class];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if(self) {
    }
    
    return self;
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

@end
