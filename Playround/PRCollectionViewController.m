//
//  PRCollectionViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 6/12/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRCollectionViewController.h"
#import "PRObjectManager.h"

@implementation PRCollectionViewController

- (Class)collectionClass {
    NSAssert(NO, @"You must override -collectionClass in PRCollectionViewController subclasses if you don't pass a model.");
    return nil;
}

- (NSString *)relationshipName {
    NSAssert(NO, @"You must override -relationshipName in PRCollectionViewController subclasses if you pass a model.");
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlDidChangeValue:)
                    forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    [self fetchCollection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)fetchCollection {
    [self.refreshControl beginRefreshing];

     void(^completion)(RKObjectRequestOperation *, RKMappingResult *, NSError *) = ^void (RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
         if(!error) {
             self.collection = mappingResult.array;
         } else {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error while fetching collection"
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             
             [alertView show];
         }
         
         [self.refreshControl endRefreshing];
         [self.tableView reloadData];
     };
    
    if(self.model)
        [self.model readRelationship:self.relationshipName completion:completion];
    else
        [self.collectionClass allWithCompletion:completion];
}

- (void)setupCell:(UITableViewCell *)cell model:(PRModel *)model {
    cell.textLabel.text = model.objectID;
}

- (IBAction)refreshControlDidChangeValue:(UIRefreshControl *)control {
    [self fetchCollection];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Model";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PRModel *model = self.collection[indexPath.row];
    
    [self setupCell:cell model:model];
    
    return cell;
}

@end