//
//  PRTeamsController.h
//  Playround
//
//  Created by Eugenio Depalo on 7/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRButtonTableViewCell.h"
#import "PRTeamViewController.h"
#import "PRRound.h"

@interface PRTeamsController : NSObject <UITableViewDataSource, PRButtonTableViewCellDelegate, PRTeamViewControllerDelegate>

@property (nonatomic, strong) PRRound *round;

- (id)initWithTableViewController:(UITableViewController *)tableViewController sectionOffset:(NSUInteger)sectionOffset;
- (void)reloadAnimated:(BOOL)animated;
- (void)updateAnimated:(BOOL)animated;

@end
