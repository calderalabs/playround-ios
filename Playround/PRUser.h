//
//  PRUser.h
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

@interface PRUser : PRModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSURL *pictureURL;

+ (void)currentWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion;

@end
