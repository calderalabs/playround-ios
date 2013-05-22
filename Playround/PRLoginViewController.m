//
//  PRLoginViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 4/29/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRLoginViewController.h"
#import "PRSession.h"

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
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didTouchFacebookConnectButton:(id)sender {
    [PRSession.current facebookConnectWithCompletion:^(PRToken *token, NSError *error) {
        if(!error)
            [self dismissViewControllerAnimated:YES completion:nil];
        else {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error while connecting to Facebook"
                                                                     message:error.localizedDescription
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
            
            [errorAlertView show];
        }
    }];
}

@end
