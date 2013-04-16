//
//  PRModel.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

@implementation PRModel

+ (RKObjectMapping *)objectMapping {
    return [RKObjectMapping mappingForClass:self];
}

+ (NSString *)keyPath {
    NSAssert(NO, @"You must override +keyPath in PRModel subclasses.");
    return nil;
}

+ (NSString *)remotePath {
    NSAssert(NO, @"You must override +remotePath in PRModel subclasses.");
    return nil;
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationAll;
}

+ (void)setObjectManager:(RKObjectManager *)objectManager {
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[self objectMapping]
                                                                                 pathPattern:nil
                                                                                     keyPath:[self keyPath]
                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    PRModelOperationType operationTypes = [self supportedOperationTypes];
    
    if(operationTypes & PRModelOperationCreate)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[self remotePath]
                                                                 method:RKRequestMethodPOST]];
    
    if(operationTypes & PRModelOperationRead)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", [self remotePath]]
                                                                 method:RKRequestMethodGET]];
    
    if(operationTypes & PRModelOperationUpdate)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", [self remotePath]]
                                                                 method:RKRequestMethodPUT]];
    
    if(operationTypes & PRModelOperationDelete)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", [self remotePath]]
                                                                 method:RKRequestMethodDELETE]];
}

@end
