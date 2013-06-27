//
//  PRTeamViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 6/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRTeamViewController.h"
#import "PRSession.h"
#import "PRUser.h"

@interface PRTeamViewController ()

@end

@implementation PRTeamViewController

- (void)setTeam:(PRTeam *)team {
    if(team != _team) {
        _team = team;
        
        self.navigationItem.title = _team.displayName;
    }
}

- (NSString *)relationshipName {
    return @"buddies";
}

- (void)awakeFromNib {
    PRUser *current = [[PRUser alloc] init];
    current.objectID = @"me";
    
    self.model = current;
}

- (void)setupCell:(UITableViewCell *)cell model:(PRUser *)user {
    cell.textLabel.text = user.name;
}

@end
