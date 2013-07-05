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
#import "PRTeam.h"
#import "PRParticipation.h"
#import "PRSession.h"
#import "PRPickerTableViewCell.h"
#import "PRSegmentedTableViewCell.h"
#import "PRActivityTableViewCell.h"
#import "PRTeamViewController.h"

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

- (void)teamSegmentedControlDidChangeValue:(UISegmentedControl *)segmentedControl;
- (IBAction)didTouchCancelBarButtonItem:(id)sender;
- (IBAction)didTouchDoneBarButtonItem:(id)sender;
- (void)updateTeamsAnimated:(BOOL)animated previousGame:(PRGame *)game;
- (void)updateTeamSegmentsAnimated:(BOOL)animated;
- (void)updateLocationCell;
- (void)reloadTeams;
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
    PRGame *previousGame = self.round.game;
    self.round.game = game;
    
    [self.round removeAllParticipants];
    [self.round addParticipant:PRSession.current.user team:game.teams[0]];
    
    if(![previousGame.objectID isEqualToString:game.objectID])
        [self updateTeamsAnimated:animated previousGame:previousGame];
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

- (void)awakeFromNib {
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
            [self dismissViewControllerAnimated:YES completion:^{
                if([self.delegate respondsToSelector:@selector(playViewControllerDidCreateRound:)])
                    [self.delegate playViewControllerDidCreateRound:self];
            }];
        }
    }];
}

- (void)updateTeamsAnimated:(BOOL)animated previousGame:(PRGame *)previousGame {
    if([self.tableView.visibleCells containsObject:self.teamCell]) {
        [self updateTeamSegmentsAnimated:animated];
    }
    
    NSInteger sectionsToAdd = self.game.teams.count - previousGame.teams.count;
    NSInteger sectionsToReload = previousGame.teams.count;
    
    [self.tableView beginUpdates];
    
    if(sectionsToAdd > 0) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(previousGame.teams.count - 1 + kPlayersSection, sectionsToAdd)] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSMutableArray *rowIndexPaths = [NSMutableArray array];
        
        for(NSInteger i = previousGame.teams.count; i < previousGame.teams.count + sectionsToAdd; i++) {
            PRTeam *team = self.game.teams[i];
            
            for(NSInteger j = 0; j < team.numberOfPlayers; j++)
                [rowIndexPaths addObject:[NSIndexPath indexPathForRow:j inSection:i + kPlayersSection]];
        }
        
        [self.tableView insertRowsAtIndexPaths:rowIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(sectionsToAdd < 0) {
        sectionsToReload += sectionsToAdd;
        
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(previousGame.teams.count - 1 + sectionsToAdd + kPlayersSection, sectionsToAdd)] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if(sectionsToReload > 0)
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(kPlayersSection, sectionsToReload)] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];
}

- (void)updateTeamSegmentsAnimated:(BOOL)animated {
    NSInteger numberOfSegments = self.teamCell.segmentedControl.numberOfSegments;
    NSInteger segmentsToAdd = self.game.teams.count - numberOfSegments;
    NSInteger segmentsToReload = numberOfSegments;

    if(segmentsToAdd > 0) {
        for(NSInteger i = numberOfSegments; i < numberOfSegments + segmentsToAdd; i++) {
            PRTeam *team = self.game.teams[i];
            [self.teamCell.segmentedControl insertSegmentWithTitle:team.displayName atIndex:i animated:animated];
        }
    }
    else if(segmentsToAdd < 0) {
        segmentsToReload += segmentsToAdd;
        
        for(NSInteger i = numberOfSegments + segmentsToAdd; i < numberOfSegments; i++)
            [self.teamCell.segmentedControl removeSegmentAtIndex:i animated:animated];
    }
    
    if(segmentsToReload > 0)
        for(NSInteger i = 0; i < segmentsToReload; i++) {
            PRTeam *team = self.game.teams[i];
            [self.teamCell.segmentedControl setTitle:team.displayName forSegmentAtIndex:i];
        }
    
    NSArray *currentUserParticipations = [self.round.participations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"user.objectID == %@", PRSession.current.user.objectID]];
    
    if(currentUserParticipations.count > 0) {
        PRParticipation *participation = currentUserParticipations[0];
        
        self.teamCell.segmentedControl.selectedSegmentIndex = [self.game.teams indexOfObjectPassingTest:^BOOL(PRTeam *team, NSUInteger idx, BOOL *stop) {
            return [team.name isEqualToString:participation.team.name];
        }];
    }
}

- (void)updateLocationCell {
    NSString *status = nil;
    
    if(self.placemark) {
        status = self.placemark.description;
        [self.locationCell stopAnimating];
    }
    else if(self.location) {
        status = self.location.description;
    }
    else {
        status = @"Updating location...";
        [self.locationCell startAnimating];
    }
    
    self.locationCell.status = status;
}

- (void)reloadTeams {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(kPlayersSection, self.game.teams.count)] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(!self.games) {
        [PRGame allWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
            if(!error) {
                self.games = mappingResult.array;
                [self setGame:self.games[0] animated:YES];
                
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
    
    [self.locationManager startUpdatingLocation];
}

- (void)teamSegmentedControlDidChangeValue:(UISegmentedControl *)segmentedControl {
    [self.round addParticipant:PRSession.current.user team:self.game.teams[segmentedControl.selectedSegmentIndex] prepend:YES];
    [self reloadTeams];
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
    return kPlayersSection + self.game.teams.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case kLocationSection: return 1;
        case kGameSection: return 1;
        case kTeamSection: return 1;
        default: {
            PRTeam *team = self.game.teams[section - kPlayersSection];
            return 1 + team.numberOfPlayers;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case kLocationSection: return @"Location";
        case kGameSection: return @"Game";
        case kTeamSection: return @"Your Team";
        default: {
            PRTeam *team = self.game.teams[section - kPlayersSection];
            return team.displayName;
        }
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
        default: {
            if(indexPath.row == 0) {
                PRButtonTableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:@"ShowTeam" forIndexPath:indexPath];
                
                buttonCell.delegate = self;
                cell = buttonCell;
            }
            else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Player" forIndexPath:indexPath];
                
                PRTeam *team = self.game.teams[indexPath.section - kPlayersSection];
                NSArray *teamParticipations = [self.round participationsForTeam:team];
                
                NSUInteger playerIndex = indexPath.row - 1;
                
                if(playerIndex < teamParticipations.count) {
                    PRParticipation *participation = teamParticipations[playerIndex];
                    cell.textLabel.text = participation.user.name;
                }
                else {
                    cell.textLabel.text = @"";
                }
            }
            
            break;
        }
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
        if(indexPath.row != 0) {
            PRTeam *team = self.game.teams[indexPath.section - kPlayersSection];
            NSArray *teamParticipations = [self.round participationsForTeam:team];
            
            if(indexPath.row - 1 < teamParticipations.count) {
                PRParticipation *participation = teamParticipations[indexPath.row - 1];
                return ![participation.user.objectID isEqualToString:PRSession.current.user.objectID];
            }
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= kPlayersSection) {
        if(indexPath.row != 0) {
            if(editingStyle == UITableViewCellEditingStyleDelete) {
                PRTeam *team = self.game.teams[indexPath.section - kPlayersSection];
                PRParticipation *participation = [self.round participationsForTeam:team][indexPath.row - 1];
                [self.round removeParticipant:participation.user];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

- (void)didTapButtonTableViewCell:(PRButtonTableViewCell *)cell {
    [self performSegueWithIdentifier:@"ShowTeam" sender:cell];
}

- (void)teamViewController:(PRTeamViewController *)teamViewController didAddParticipants:(NSArray *)participants {
    [self reloadTeams];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowTeam"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PRTeamViewController *teamViewController = segue.destinationViewController;
    
        teamViewController.delegate = self;
        teamViewController.team = self.game.teams[indexPath.section - kPlayersSection];
        teamViewController.round = self.round;
    }
}

@end
