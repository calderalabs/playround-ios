//
//  PRTeamViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 6/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRTeamViewController.h"
#import "PRSession.h"
#import "PRUser.h"
#import "PRParticipation.h"

@interface PRTeamViewController ()

- (IBAction)didTapDoneBarButtonItem:(UIBarButtonItem *)sender;

@end

@implementation PRTeamViewController

- (void)setTeam:(PRTeam *)team {
    if(team != _team) {
        _team = team;
        
        self.navigationItem.title = _team.descriptor.displayName;
        [self.tableView reloadData];
    }
}

- (void)setRound:(PRRound *)round {
    if(round != _round) {
        _round = round;

        [self.tableView reloadData];
    }
}

- (NSString *)relationshipName {
    return @"buddies";
}

- (void)awakeFromNib {
    PRUser *current = [[PRUser alloc] init];
    current.objectID = @"me";
    
    self.model = current;
}

- (void)setupCell:(UITableViewCell *)cell model:(PRUser *)user {
    cell.textLabel.text = user.name;
    
    if([self.round hasParticipant:user]) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.tableView.indexPathsForSelectedRows.count + self.team.participations.count >= self.team.descriptor.numberOfPlayers)
        return nil;
    
    return indexPath;
}

- (IBAction)didTapDoneBarButtonItem:(UIBarButtonItem *)sender {
    NSMutableArray *participations = [NSMutableArray array];
    
    for(NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        PRUser *user = self.collection[indexPath.row];
        [participations addObject:[self.round addParticipant:user team:self.team prepend:NO]];
    }

    if([self.delegate respondsToSelector:@selector(teamViewController:didAddParticipations:)])
        [self.delegate teamViewController:self didAddParticipations:participations];
}

@end
