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

- (IBAction)didTouchFacebookConnectButton:(id)sender;

@end

@implementation PRLoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [PRUser readCurrentWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error) {
        if(!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            
            if(response.statusCode != 401)
                [[[UIAlertView alloc] initWithTitle:@"Connection Error"
                                            message:error.localizedDescription
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil] show];
        }
    }];
}

- (IBAction)didTouchFacebookConnectButton:(id)sender {
    [PRSession.current facebookConnectWithCompletion:^(PRToken *token, NSError *error) {
        if(!error)
            [self dismissViewControllerAnimated:YES completion:nil];
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error While Connecting to Facebook"
                                                                     message:error.localizedDescription
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil] show];
        }
    }];
}

@end
