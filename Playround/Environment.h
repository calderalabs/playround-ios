//
//  Environment.h
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#ifndef Playround_Environment_h
#define Playround_Environment_h

#ifdef RELEASE
#define PR_API_BASE_URL @"http://goplayround.com"
#define PR_API_ACCESS_TOKEN nil
#elif DEBUG
#define PR_API_BASE_URL @"http://localhost:8080"
#define PR_API_ACCESS_TOKEN @"00000000000000000000000000000000"
#endif

#endif
