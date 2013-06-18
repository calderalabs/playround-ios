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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if(self) {
    }
    
    return self;
}

- (void)awakeFromNib {
    PRUser *current = [[PRUser alloc] init];
    current.objectID = @"me";
    
    self.model = current;
}

@end
