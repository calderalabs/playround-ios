//
//  PRUser.h
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

extern NSString *PRUserDidReadCurrentNotification;

@interface PRUser : PRModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pictureURL;
@property (nonatomic, copy) NSString *facebookID;

+ (void)readCurrentWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion;

@end
