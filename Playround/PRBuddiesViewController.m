//
//  PRBuddiesViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 6/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRBuddiesViewController.h"
#import "PRSession.h"
#import "PRUser.h"

@interface PRBuddiesViewController ()

@end

@implementation PRBuddiesViewController

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
