//
//  PRRelationshipMapping.h
//  Playround
//
//  Created by Eugenio Depalo on 8/26/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRPropertyMapping.h"

@interface PRRelationshipMapping : PRPropertyMapping

@property (nonatomic, retain) Class objectClass;

- (id)objectForKeyedSubscript:(id)key;

@end
