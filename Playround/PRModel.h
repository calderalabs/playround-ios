//
//  PRModel.h
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRObjectMapping.h"

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

+ (NSArray *)modelClasses;
+ (void)registerClass:(Class)modelClass;
+ (PRModelOperationType)supportedOperationTypes;
+ (PRObjectMapping *)objectMapping;
+ (NSString *)remotePrimaryKey;
+ (NSString *)keyPath;
+ (NSString *)pluralKeyPath;
+ (NSString *)remotePath;
+ (NSString *)versionedPathFromPath:(NSString *)path;
+ (NSString *)versionedRemotePath;
+ (NSDictionary *)relationships;
+ (void)setObjectManager:(RKObjectManager *)objectManager;
+ (void)allWithCompletion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error))completion;
+ (void)allWhere:(NSDictionary *)parameters
      completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error))completion;

- (void)readRelationship:(NSString *)relationship completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingOperation, NSError *error))completion;
- (void)readRelationship:(NSString *)relationship where:(NSDictionary *)parameters completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingOperation, NSError *error))completion;
- (void)createRelationship:(id)object name:(NSString *)name completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingOperation, NSError *error))completion;
- (void)readWithCompletion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error))completion;
- (void)createWithCompletion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error))completion;
- (void)updateWithCompletion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult, NSError *error))completion;

@end
