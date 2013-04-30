//
//  PRModel.h
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

typedef enum {
   PRModelOperationNone = 0,
   PRModelOperationCreate = 1,
   PRModelOperationRead = 1 << 1,
   PRModelOperationUpdate = 1 << 2,
   PRModelOperationDelete = 1 << 3,
   PRModelOperationAll = (1 << 4) - 1
} PRModelOperationType;

@interface PRModel : NSObject

@property (nonatomic, copy) NSString *objectID;

+ (PRModelOperationType)supportedOperationTypes;
+ (RKObjectMapping *)objectMapping;
+ (NSString *)keyPath;
+ (NSString *)remotePath;
+ (void)setObjectManager:(RKObjectManager *)objectManager;
+ (void)allWithCompletion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error))completion;
+ (void)allWhere:(NSDictionary *)parameters
      completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error))completion;

- (void)getWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion;

@end
