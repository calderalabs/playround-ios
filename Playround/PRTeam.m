//
//  PRTeam.m
//  Playround
//
//  Created by Eugenio Depalo on 7/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRTeam.h"
#import "PRParticipation.h"

@implementation PRTeam

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)keyPath {
    return nil;
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping *mapping = [super objectMapping];
    
    [mapping addMappingsFromDictionary:@{
        @"name": @"descriptor.name",
        @"display_name@response": @"descriptor.displayName",
        @"number_of_players@response": @"descriptor.numberOfPlayers",
        @"winner@response": @"winner",
        @"participations": @"participations@PRParticipation"
    }];
    
    return mapping;
}

- (PRParticipation *)addParticipant:(PRUser *)user prepend:(BOOL)prepend {
    PRParticipation *participation = [[PRParticipation alloc] init];
    participation.user = user;
    participation.team = self;
    
    if(prepend)
        [_participations insertObject:participation atIndex:0];
    else
        [_participations addObject:participation];
    
    if(_participations.count > self.descriptor.numberOfPlayers) {
        NSArray *exceedingTeamParticipations = [_participations objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.descriptor.numberOfPlayers, _participations.count - self.descriptor.numberOfPlayers)]];
        [_participations removeObjectsInArray:exceedingTeamParticipations];
    }
    
    return participation;
}

- (void)removeParticipant:(PRUser *)user {
    NSUInteger userIndex = [_participations indexOfObjectPassingTest:^BOOL(PRParticipation *participation, NSUInteger idx, BOOL *stop) {
        return [participation.user.objectID isEqualToString:user.objectID];
    }];
    
    if(userIndex != NSNotFound)
        [_participations removeObjectAtIndex:userIndex];
}

- (void)removeAllParticipants {
    [_participations removeAllObjects];
}

- (NSArray *)participations {
    return [NSArray arrayWithArray:_participations];
}

- (id)init {
    self = [super init];
    
    if(self) {
        _participations = [NSMutableArray array];
        self.descriptor = [[PRTeamDescriptor alloc] init];
    }
    
    return self;
}

@end
