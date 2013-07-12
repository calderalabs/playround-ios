//
//  PRRoundViewController.h
//  Playround
//
//  Created by Eugenio Depalo on 7/9/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRound.h"
#import "PRButtonTableViewCell.h"

@interface PRRoundViewController : UITableViewController <PRButtonTableViewCellDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) PRRound *round;

@end