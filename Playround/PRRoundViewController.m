//
//  PRRoundViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 7/9/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRoundViewController.h"
#import "PRStart.h"
#import "PRWinning.h"
#import "PRTeamsController.h"

@interface PRRoundViewController ()

@property (nonatomic, weak) UIActionSheet *startActionSheet;
@property (nonatomic, weak) UIActionSheet *winActionSheet;
@property (nonatomic, strong) PRTeamsController *teamsController;

@end

enum {
    kStateSection = 0,
    kPlayersSection
};

@implementation PRRoundViewController

- (void)setRound:(PRRound *)round {
    if(round != _round ) {
        _round = round;
        self.teamsController.round = round;
    }
}

- (void)awakeFromNib {
    self.teamsController = [[PRTeamsController alloc] initWithTableViewController:self sectionOffset:kPlayersSection];
    self.teamsController.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch(indexPath.section) {
        case kStateSection: {
            if([self.round.state isEqualToString:@"over"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Winner" forIndexPath:indexPath];
                cell.textLabel.text = [NSString stringWithFormat:@"%@ has won!", self.round.winningTeam.descriptor.displayName];
            }
            else {
                NSString *cellIdentifier;
                
                if([self.round.state isEqualToString:@"waiting_for_players"])
                    cellIdentifier = @"Start";
                else if([self.round.state isEqualToString:@"ongoing"])
                    cellIdentifier = @"Win";
                
                PRButtonTableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                buttonCell.delegate = self;
                
                cell = buttonCell;
            }
            
            break;
        }
            
        default: return [self.teamsController tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + [self.teamsController numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case kStateSection: return 1;
        default: return [self.teamsController tableView:tableView numberOfRowsInSection:section];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case kStateSection: return nil;
        default: return [self.teamsController tableView:tableView titleForHeaderInSection:section];
    }
}

- (void)didTapButtonTableViewCell:(PRButtonTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if(indexPath.section == kStateSection) {
        if([self.round.state isEqualToString:@"waiting_for_players"]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to start this round?" delegate:self cancelButtonTitle:@"Don't Start" destructiveButtonTitle:nil otherButtonTitles:@"Start", nil];
            
            [actionSheet showInView:UIApplication.sharedApplication.keyWindow];
            
            self.startActionSheet = actionSheet;
        }
        else if([self.round.state isEqualToString:@"ongoing"]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Which team?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for(PRTeam *team in self.round.teams)
                [actionSheet addButtonWithTitle:team.descriptor.displayName];
            
            [actionSheet showInView:UIApplication.sharedApplication.keyWindow];
            
            self.winActionSheet = actionSheet;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(actionSheet == self.startActionSheet) {
        PRStart *start = [[PRStart alloc] init];
        start.round = self.round;

        [start createWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
            if(!error) {
                self.round = start.round;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kStateSection]]withRowAnimation:UITableViewRowAnimationAutomatic];
            
            }
        }];
    }
    else if(actionSheet == self.winActionSheet) {
        if(buttonIndex != actionSheet.cancelButtonIndex) {
            PRWinning *winning = [[PRWinning alloc] init];
            winning.round = self.round;
            winning.team = self.round.teams[buttonIndex - 1];

            [winning createWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
                if(!error) {
                    self.round = winning.round;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kStateSection]]withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
            }];
        }
    }
}

- (void)teamViewController:(PRTeamViewController *)teamViewController didAddParticipations:(NSArray *)participations {
    if(participations.count == 0)
        [self.navigationController popViewControllerAnimated:YES];
    else
        for(PRParticipation *participation in participations)
            participation.team = teamViewController.team;

        [self.round createRelationship:participations name:@"participations" completion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
}

@end
