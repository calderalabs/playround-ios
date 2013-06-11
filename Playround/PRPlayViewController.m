//
//  PRPlayViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 5/27/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRPlayViewController.h"
#import "PRGame.h"
#import "PRRound.h"
#import "PRPickerTableViewCell.h"
#import "PRSegmentedTableViewCell.h"

static const NSUInteger kUTF8LetterOffset = 65;

enum {
    kGameSection = 0,
    kPlayersSection,
    kTeamSection
};

@interface PRPlayViewController ()

@property (nonatomic, strong) PRRound *round;
@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, weak) PRPickerTableViewCell *gamePickerCell;
@property (nonatomic, weak) PRSegmentedTableViewCell *teamCell;

- (IBAction)didTouchCancelBarButtonItem:(id)sender;
- (void)updateTeamsAnimated:(BOOL)animated;
- (void)setup;

@end

@implementation PRPlayViewController

- (void)setup {
    self.round = [[PRRound alloc] init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

- (IBAction)didTouchCancelBarButtonItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTeamsAnimated:(BOOL)animated {
    if([self.tableView.visibleCells containsObject:self.teamCell]) {
        NSInteger numberOfSegments = self.teamCell.segmentedControl.numberOfSegments;
        NSInteger segmentsToAdd = self.round.game.numberOfTeams - numberOfSegments;
        
        if(segmentsToAdd > 0) {
            for(NSInteger i = numberOfSegments; i < self.round.game.numberOfTeams; i++) {
                char letter = (i + kUTF8LetterOffset);
                NSString *title = [NSString stringWithFormat:@"Team %@", [NSString stringWithUTF8String:&letter]];
                [self.teamCell.segmentedControl insertSegmentWithTitle:title atIndex:i animated:animated];
            }
        }
        else {
            for(NSInteger i = numberOfSegments - 1; i > numberOfSegments - 1 + segmentsToAdd; i--) {
                [self.teamCell.segmentedControl removeSegmentAtIndex:i animated:animated];
            }
        }

        self.teamCell.segmentedControl.selectedSegmentIndex = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(!self.games) {
        [PRGame allWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
            if(!error) {
                self.games = mappingResult.array;
                self.round.game = self.games[0];
                [self updateTeamsAnimated:NO];
                
                if([self.tableView.visibleCells containsObject:self.gamePickerCell])
                    [self.gamePickerCell.pickerView reloadAllComponents];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error while fetching games"
                                                                    message:error.localizedDescription
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                
                [alertView show];
            }
        }];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.games.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PRGame *game = self.games[row];
    return game.displayName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.round.game = self.games[row];
    [self updateTeamsAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case kGameSection:
            return @"Game";
            break;
        case kPlayersSection:
            return @"Players";
            break;
        case kTeamSection:
            return @"Your Team";
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch(indexPath.section) {
        case kGameSection: {
            PRPickerTableViewCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:@"Game" forIndexPath:indexPath];
            
            pickerCell.pickerView.delegate = self;
            pickerCell.pickerView.dataSource = self;
            
            cell = pickerCell;
            self.gamePickerCell = pickerCell;
            
            break;
        }
        case kPlayersSection: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Players" forIndexPath:indexPath];
            break;
        }
        case kTeamSection: {
            PRSegmentedTableViewCell *segmentedCell = [tableView dequeueReusableCellWithIdentifier:@"Team" forIndexPath:indexPath];
            
            cell = segmentedCell;
            self.teamCell = segmentedCell;
            [self updateTeamsAnimated:NO];
            
            break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case kGameSection:
            return 216;
            break;
        default:
            return 44;
            break;
    }
}

@end
