//
//  PRRoundViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 7/9/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRoundViewController.h"
#import "PRStart.h"

enum {
    kPlaySection = 0
};

@implementation PRRoundViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch(indexPath.row) {
        case kPlaySection: {
            PRButtonTableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:@"Play" forIndexPath:indexPath];
            buttonCell.delegate = self;
            
            cell = buttonCell;
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)didTapButtonTableViewCell:(PRButtonTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if(indexPath.section == kPlaySection) {
        PRStart *start = [[PRStart alloc] init];
        start.round = self.round;
        [start createWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

@end
