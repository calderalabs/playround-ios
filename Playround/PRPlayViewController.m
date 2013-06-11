//
//  PRPlayViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 5/27/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRPlayViewController.h"
#import "PRGame.h"
#import "PRPickerTableViewCell.h"

enum {
    kGameSection = 0,
    kPlayersSection,
    kYourTeamSection
};

@interface PRPlayViewController ()

@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, weak) PRPickerTableViewCell *gamePickerCell;

- (IBAction)didTouchCancelBarButtonItem:(id)sender;

@end

@implementation PRPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
    }
    
    return self;
}

- (IBAction)didTouchCancelBarButtonItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(!self.games) {
        [PRGame allWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
            if(!error) {
                self.games = mappingResult.array;
                
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
        case kYourTeamSection:
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
        case kPlayersSection:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Players" forIndexPath:indexPath];
            break;
        case kYourTeamSection:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Team" forIndexPath:indexPath];
            break;
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
