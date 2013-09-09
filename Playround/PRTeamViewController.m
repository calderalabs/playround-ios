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
#import "PRFacebookUser.h"

enum {
    kFacebookSection = 1
};

@interface PRTeamViewController ()

@property (nonatomic, retain) NSArray *facebookFriends;

- (IBAction)didTapDoneBarButtonItem:(UIBarButtonItem *)sender;
- (void)disableCell:(UITableViewCell *)cell;

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

- (void)fetchCollection {
    [super fetchCollection];
    
    [PRFacebookUser.defaultUser readFriendsWithCompletion:^(NSArray *friends, NSError *error) {
        self.facebookFriends = friends;
        [self.tableView reloadData];
    }];
}

- (void)disableCell:(UITableViewCell *)cell {
    cell.userInteractionEnabled = NO;
    cell.textLabel.enabled = NO;
}

- (void)setupCell:(UITableViewCell *)cell withModel:(PRUser *)user {
    cell.textLabel.text = user.name;
    
    if([self.round hasParticipant:user]) {
        [self disableCell:cell];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == kFacebookSection)
        return @"Facebook Friends";
    
    return @"Buddies";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView] + kFacebookSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == kFacebookSection)
        return self.facebookFriends.count;
    else
        return [super tableView:tableView numberOfRowsInSection:section];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.tableView.indexPathsForSelectedRows.count + self.team.participations.count >= self.team.descriptor.numberOfPlayers)
        return nil;
    
    return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == kFacebookSection) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Model" forIndexPath:indexPath];
        NSDictionary *friend = self.facebookFriends[indexPath.row];
        
        cell.textLabel.text = friend[@"name"];
        
        if([self.round.teams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%@ IN participations.user.facebookID", friend[@"id"]]].count > 0)
            [self disableCell:cell];
        
        return cell;
    }
    else
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (IBAction)didTapDoneBarButtonItem:(UIBarButtonItem *)sender {
    NSMutableArray *participations = [NSMutableArray array];
    
    for(NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        PRUser *user;
        
        if(indexPath.section == kFacebookSection) {
            NSDictionary *friend = self.facebookFriends[indexPath.row];
            
            user = [[PRUser alloc] init];
            user.facebookID = friend[@"id"];
            user.name = friend[@"name"];
        }
        else {
            user = self.collection[indexPath.row];
        }
        
        [participations addObject:[self.round addParticipant:user toTeam:self.team prepend:NO]];
    }

    if([self.delegate respondsToSelector:@selector(teamViewController:didAddParticipations:)])
        [self.delegate teamViewController:self didAddParticipations:participations];
}

@end
