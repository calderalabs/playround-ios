//
//  PRLoginViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 4/29/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRLoginViewController.h"
#import "PRUser.h"

@interface PRLoginViewController ()

@end

@implementation PRLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [PRUser readCurrentWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
        if(!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
