//
//  PRPlayViewController.h
//  Playround
//
//  Created by Eugenio Depalo on 5/27/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRButtonTableViewCell.h"
#import "PRTeamViewController.h"

@class PRPlayViewController;

@protocol PRPlayViewControllerDelegate <NSObject>

@optional

- (void)playViewControllerDidCreateRound:(PRPlayViewController *)playViewController;

@end

@interface PRPlayViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, PRButtonTableViewCellDelegate, PRTeamViewControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) id<PRPlayViewControllerDelegate> delegate;

@end
