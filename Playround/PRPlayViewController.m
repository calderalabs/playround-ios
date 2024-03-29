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
#import "PRSession.h"
#import "PRTeamDescriptor.h"
#import "PRParticipation.h"
#import "PRPickerTableViewCell.h"
#import "PRSegmentedTableViewCell.h"
#import "PRActivityTableViewCell.h"
#import "PRTeamsController.h"

enum {
    kLocationSection = 0,
    kGameSection,
    kTeamSection,
    kPlayersSection
};

@interface PRPlayViewController ()

@property (nonatomic, strong) PRRound *round;
@property (nonatomic, strong) PRGame *game;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) CLLocation *location;
@property (nonatomic, copy) CLPlacemark *placemark;
@property (nonatomic, copy) NSArray *games;
@property (nonatomic, copy) NSArray *sections;
@property (nonatomic, weak) PRPickerTableViewCell *gamePickerCell;
@property (nonatomic, weak) PRSegmentedTableViewCell *teamCell;
@property (nonatomic, weak) PRActivityTableViewCell *locationCell;
@property (nonatomic, strong) PRTeamsController *teamsController;

- (void)teamSegmentedControlDidChangeValue:(UISegmentedControl *)segmentedControl;
- (IBAction)didTouchCancelBarButtonItem:(id)sender;
- (IBAction)didTouchDoneBarButtonItem:(id)sender;
- (void)updateTeamSegmentsAnimated:(BOOL)animated;
- (void)updateLocationCell;
- (void)setGame:(PRGame *)game animated:(BOOL)animated;

@end

@implementation PRPlayViewController

- (PRGame *)game {
    return self.round.game;
}

- (void)setGame:(PRGame *)game {
    [self setGame:game animated:NO];
}

- (void)setGame:(PRGame *)game animated:(BOOL)animated {
    self.round.game = game;
    [self.round addParticipant:PRSession.current.user toTeam:self.round.teams[0] prepend:YES];
    [self.teamsController updateAnimated:animated];
    
    if([self.tableView.visibleCells containsObject:self.teamCell]) {
        [self updateTeamSegmentsAnimated:animated];
    }
}

- (void)setLocation:(CLLocation *)location {
    if(location != _location) {
        _location = location;
        self.round.arena.latitude = location.coordinate.latitude;
        self.round.arena.longitude = location.coordinate.longitude;
        
        if([self.tableView.visibleCells containsObject:self.locationCell])
            [self updateLocationCell];
        
        [self.geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
            self.placemark = [placemarks lastObject];
        }];
    }
}

- (void)setPlacemark:(CLPlacemark *)placemark {
    if(placemark != _placemark) {
        _placemark = placemark;
        
        if([self.tableView.visibleCells containsObject:self.locationCell])
            [self updateLocationCell];
    }
}

- (void)setRound:(PRRound *)round {
    if(round != _round) {
        _round = round;
        
        self.teamsController.round = round;
    }
}

- (void)awakeFromNib {
    self.teamsController = [[PRTeamsController alloc] initWithTableViewController:self sectionOffset:kPlayersSection];
    self.teamsController.delegate = self;
    self.round = [[PRRound alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.geocoder = [[CLGeocoder alloc] init];
}

- (IBAction)didTouchCancelBarButtonItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTouchDoneBarButtonItem:(id)sender {
    [self.round createWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
        if(error) {
            NSString *responseString = error.userInfo[NSLocalizedRecoverySuggestionErrorKey];
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *errors = response[@"errors"];
            NSMutableString *message = [NSMutableString string];
            
            for(NSString *attribute in errors) {
                NSArray *errorMessages = errors[attribute];
                [message appendFormat:@"%@ %@\n", attribute, [errorMessages componentsJoinedByString:@","]];
            }
            
            [[[UIAlertView alloc] initWithTitle:@"Error While Creating Round"
                                        message:message
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)updateTeamSegmentsAnimated:(BOOL)animated {
    NSInteger numberOfSegments = self.teamCell.segmentedControl.numberOfSegments;
    NSInteger segmentsToAdd = self.round.teams.count - numberOfSegments;
    NSInteger segmentsToReload = numberOfSegments;

    if(segmentsToAdd > 0) {
        for(NSInteger i = numberOfSegments; i < numberOfSegments + segmentsToAdd; i++) {
            PRTeamDescriptor *teamDescriptor = self.game.teamDescriptors[i];
            [self.teamCell.segmentedControl insertSegmentWithTitle:teamDescriptor.displayName atIndex:i animated:animated];
        }
    }
    else if(segmentsToAdd < 0) {
        segmentsToReload += segmentsToAdd;
        
        for(NSInteger i = numberOfSegments + segmentsToAdd; i < numberOfSegments; i++)
            [self.teamCell.segmentedControl removeSegmentAtIndex:i animated:animated];
    }
    
    if(segmentsToReload > 0)
        for(NSInteger i = 0; i < segmentsToReload; i++) {
            PRTeamDescriptor *team = self.game.teamDescriptors[i];
            [self.teamCell.segmentedControl setTitle:team.displayName forSegmentAtIndex:i];
        }
    
    self.teamCell.segmentedControl.selectedSegmentIndex = [self.game.teamDescriptors indexOfObjectPassingTest:^BOOL(PRTeamDescriptor *teamDescriptor, NSUInteger idx, BOOL *stop) {
        NSArray *teams = [self.round.teams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"descriptor.name == %@", teamDescriptor.name]];
        PRTeam *team = teams[0];
        
        return [team.participations indexOfObjectPassingTest:^BOOL(PRParticipation *participation, NSUInteger idx, BOOL *stop) {
            return [participation.user.objectID isEqualToString:PRSession.current.user.objectID];
        }] != NSNotFound;
    }];
}

- (void)updateLocationCell {
    NSString *status = nil;
    
    if(self.placemark) {
        status = self.placemark.description;
        [self.locationCell stopAnimating];
    }
    else if(self.location) {
        TTTLocationFormatter *locationFormatter = [[TTTLocationFormatter alloc] init];
        status = [locationFormatter stringFromLocation:self.location];
        [self.locationCell startAnimating];
    }
    else {
        status = @"Updating location...";
        [self.locationCell startAnimating];
    }
    
    self.locationCell.status = status;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(!self.games) {
        [PRGame allWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
            if(!error) {
                self.games = mappingResult.array;
                
                if(self.games.count > 0)
                    [self setGame:self.games[0] animated:YES];
                
                if([self.tableView.visibleCells containsObject:self.gamePickerCell])
                    [self.gamePickerCell.pickerView reloadAllComponents];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error While Fetching Games"
                                                                    message:error.localizedDescription
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                
                [alertView show];
            }
        }];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)teamSegmentedControlDidChangeValue:(UISegmentedControl *)segmentedControl {
    [self.round addParticipant:PRSession.current.user toTeam:self.round.teams[segmentedControl.selectedSegmentIndex] prepend:YES];
    [self.teamsController reloadAnimated:YES];
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
    [self setGame:self.games[row] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kPlayersSection + [self.teamsController numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case kLocationSection: return 1;
        case kGameSection: return 1;
        case kTeamSection: return 1;
        default: return [self.teamsController tableView:tableView numberOfRowsInSection:section];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case kLocationSection: return @"Location";
        case kGameSection: return @"Game";
        case kTeamSection: return @"Your Team";
        default: return [self.teamsController tableView:tableView titleForHeaderInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch(indexPath.section) {
        case kLocationSection: {
            PRActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"Location" forIndexPath:indexPath];
            
            cell = activityCell;
            self.locationCell = activityCell;
            [self updateLocationCell];
            
            break;
        }
        case kGameSection: {
            PRPickerTableViewCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:@"Game" forIndexPath:indexPath];
            
            pickerCell.pickerView.delegate = self;
            pickerCell.pickerView.dataSource = self;
            
            cell = pickerCell;
            self.gamePickerCell = pickerCell;
            
            break;
        }
        case kTeamSection: {
            PRSegmentedTableViewCell *segmentedCell = [tableView dequeueReusableCellWithIdentifier:@"Team" forIndexPath:indexPath];
            
            [segmentedCell.segmentedControl removeAllSegments];
            [segmentedCell.segmentedControl addTarget:self action:@selector(teamSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
            
            cell = segmentedCell;
            self.teamCell = segmentedCell;
            [self updateTeamSegmentsAnimated:NO];
            
            break;
        }
        default: return [self.teamsController tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case kGameSection: return 216;
        default: return 44;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= kPlayersSection) {
        return [self.teamsController tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= kPlayersSection) {
        if(indexPath.row != 0) {
            if(editingStyle == UITableViewCellEditingStyleDelete) {
                PRTeam *team = self.round.teams[indexPath.section - kPlayersSection];
                PRParticipation *participation = team.participations[indexPath.row - 1];
                
                [self.round removeParticipant:participation.user fromTeam:team];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
}

- (void)teamViewController:(PRTeamViewController *)teamViewController didAddParticipations:(NSArray *)participations {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
