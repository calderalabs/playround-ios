//
//  PRTeamViewController.h
//  Playround
//
//  Created by Eugenio Depalo on 6/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRCollectionViewController.h"
#import "PRTeam.h"
#import "PRRound.h"

@class PRTeamViewController;

@protocol PRTeamViewControllerDelegate <NSObject>

@optional

- (void)teamViewController:(PRTeamViewController *)teamViewController didAddParticipants:(NSArray *)participants;

@end

@interface PRTeamViewController : PRCollectionViewController

@property (nonatomic, strong) PRTeam *team;
@property (nonatomic, strong) PRRound *round;
@property (nonatomic, weak) id<PRTeamViewControllerDelegate> delegate;

@end
