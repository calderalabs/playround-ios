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

@interface PRRoundViewController ()

@property (nonatomic, weak) UIActionSheet *startActionSheet;
@property (nonatomic, weak) UIActionSheet *winActionSheet;

@end

enum {
    kStateSection = 0
};

@implementation PRRoundViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch(indexPath.row) {
        case kStateSection: {
            if([self.round.state isEqualToString:@"over"]) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Winner" forIndexPath:indexPath];
                cell.textLabel.text = [NSString stringWithFormat:@"Team A has won!"];
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
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)didTapButtonTableViewCell:(PRButtonTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if(indexPath.section == kStateSection) {
        if([self.round.state isEqualToString:@"waiting_for_players"]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to start this round?" delegate:self cancelButtonTitle:@"Don't Start" destructiveButtonTitle:nil otherButtonTitles:@"Start", nil];
            
            [actionSheet showFromRect:cell.frame inView:self.tableView animated:YES];
            
            self.startActionSheet = actionSheet;
        }
        else if([self.round.state isEqualToString:@"ongoing"]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Which team?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            
            for(PRTeam *team in self.round.teams)
                [actionSheet addButtonWithTitle:team.descriptor.name];
            
            [actionSheet showFromRect:cell.frame inView:self.tableView animated:YES];
            
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
                self.round.state = @"ongoing";
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
                    self.round.state = @"over";
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:kStateSection]]withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
            }];
        }
    }
}

@end
