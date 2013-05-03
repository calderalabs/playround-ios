//
//  PRHTTPRequestOperation.m
//  Playround
//
//  Created by Eugenio Depalo on 5/3/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRHTTPRequestOperation.h"

@implementation PRHTTPRequestOperation

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    
    if(self) {
        [self setRedirectResponseBlock:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
            NSMutableURLRequest *request_ = [connection.originalRequest mutableCopy];
            [request_ setURL:[request URL]];
            return request_;
        }];
    }
    
    return self;
}

@end
