//
//  PRCollectionViewController.h
//  Playround
//
//  Created by Eugenio Depalo on 6/12/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

@interface PRCollectionViewController : UITableViewController

@property (nonatomic, strong) NSArray *collection;
@property (nonatomic, weak, readonly) Class collectionClass;
@property (nonatomic, copy, readonly) NSString *relationshipName;
@property (nonatomic, strong) PRModel *model;

- (void)setupCell:(UITableViewCell *)cell model:(PRModel *)model;
- (void)fetchCollection;

@end
