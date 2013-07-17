//
//  PRTeamsController.m
//  Playround
//
//  Created by Eugenio Depalo on 7/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRTeamsController.h"
#import "PRTeam.h"
#import "PRParticipation.h"
#import "PRSession.h"
#import "PRTeamViewController.h"

@interface PRTeamsController ()

@property (nonatomic, assign) NSUInteger sectionOffset;
@property (nonatomic, strong) UITableViewController *tableViewController;
@property (nonatomic, copy) NSArray *previousTeams;

@end

@implementation PRTeamsController

- (id)initWithTableViewController:(UITableViewController *)tableViewController sectionOffset:(NSUInteger)sectionOffset {
    self = [super init];
    
    if(self) {
        self.tableViewController = tableViewController;
        self.sectionOffset = sectionOffset;
        
        [tableViewController.tableView registerNib:[UINib nibWithNibName:@"ShowTeamTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShowTeam"];
        [tableViewController.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Player"];
    }
    
    return self;
}

- (id)init {
    return [self initWithTableViewController:nil sectionOffset:0];
}

- (void)setRound:(PRRound *)round {
    if(round != _round) {
        _round = round;
        
        [self updateAnimated:NO];
    }
}

- (void)updateAnimated:(BOOL)animated {
    UITableViewRowAnimation rowAnimation = animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone;
    NSInteger sectionsToAdd = self.round.teams.count - self.previousTeams.count;
    NSInteger sectionsToReload = self.previousTeams.count;
    
    [self.tableViewController.tableView beginUpdates];
    
    if(sectionsToAdd > 0) {
        [self.tableViewController.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.previousTeams.count - 1 + self.sectionOffset, sectionsToAdd)] withRowAnimation:rowAnimation];
        
        NSMutableArray *rowIndexPaths = [NSMutableArray array];
        
        for(NSInteger i = self.previousTeams.count; i < self.previousTeams.count + sectionsToAdd; i++) {
            PRTeam *team = self.round.teams[i];
            
            for(NSInteger j = 0; j < team.descriptor.numberOfPlayers; j++)
                [rowIndexPaths addObject:[NSIndexPath indexPathForRow:j inSection:i + self.sectionOffset]];
        }
        
        [self.tableViewController.tableView insertRowsAtIndexPaths:rowIndexPaths withRowAnimation:rowAnimation];
    }
    else if(sectionsToAdd < 0) {
        sectionsToReload += sectionsToAdd;
        
        [self.tableViewController.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.previousTeams.count - 1 + sectionsToAdd + self.sectionOffset, sectionsToAdd)] withRowAnimation:rowAnimation];
    }
    
    if(sectionsToReload > 0)
        [self.tableViewController.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.sectionOffset, sectionsToReload)] withRowAnimation:rowAnimation];
    
    [self.tableViewController.tableView endUpdates];
    
    self.previousTeams = self.round.teams;
}

- (void)reloadAnimated:(BOOL)animated {
    [self.tableViewController.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.sectionOffset, self.round.teams.count)] withRowAnimation:animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PRTeam *team = self.round.teams[section - self.sectionOffset];
    return 1 + team.descriptor.numberOfPlayers;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.round.teams.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    PRTeam *team = self.round.teams[section - self.sectionOffset];
    return team.descriptor.displayName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if(indexPath.row == 0) {
        PRButtonTableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:@"ShowTeam" forIndexPath:indexPath];
        
        buttonCell.delegate = self;
        cell = buttonCell;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Player" forIndexPath:indexPath];
        
        PRTeam *team = self.round.teams[indexPath.section - self.sectionOffset];
        NSUInteger playerIndex = indexPath.row - 1;
        
        if(playerIndex < team.participations.count) {
            PRParticipation *participation = team.participations[playerIndex];
            cell.textLabel.text = participation.user.name;
        }
        else {
            cell.textLabel.text = @"";
        }
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row != 0) {
        PRTeam *team = self.round.teams[indexPath.section - self.sectionOffset];
        
        if(indexPath.row - 1 < team.participations.count) {
            PRParticipation *participation = team.participations[indexPath.row - 1];
            return ![participation.user.objectID isEqualToString:PRSession.current.user.objectID];
        }
    }
    
    return NO;
}

- (void)didTapButtonTableViewCell:(PRButtonTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableViewController.tableView indexPathForCell:cell];
    
    if(indexPath.row == 0) {
        PRTeamViewController *teamViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"TeamViewController"];
        
        teamViewController.delegate = self;
        teamViewController.team = self.round.teams[indexPath.section - self.sectionOffset];
        teamViewController.round = self.round;
        
        [self.tableViewController.navigationController pushViewController:teamViewController animated:YES];
    }
}

- (void)teamViewController:(PRTeamViewController *)teamViewController didAddParticipants:(NSArray *)participants {
    [self reloadAnimated:YES];
}

@end
