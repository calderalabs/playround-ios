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

@interface PRTeamViewController ()

- (IBAction)didTapDoneBarButtonItem:(UIBarButtonItem *)sender;

@end

@implementation PRTeamViewController

- (void)setTeam:(PRTeam *)team {
    if(team != _team) {
        _team = team;
        
        self.navigationItem.title = _team.displayName;
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
    
    if([[self.round.participations valueForKey:@"objectID"] containsObject:user.objectID]) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.tableView.indexPathsForSelectedRows.count + self.round.participations.count  >= self.team.numberOfPlayers)
        return nil;
    
    return indexPath;
}

- (IBAction)didTapDoneBarButtonItem:(UIBarButtonItem *)sender {
    NSMutableArray *participations = [NSMutableArray array];

    for(NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows)
        [participations addObject:[self.collection objectAtIndex:indexPath.row]];
    
    self.round.participations = [self.round.participations arrayByAddingObjectsFromArray:participations];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
