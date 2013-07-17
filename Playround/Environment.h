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
#define PR_API_BASE_URL @"http://api.goplayround.com"
#elif DEBUG
#define PR_API_BASE_URL @"http://localhost:8080"
#define PR_FACEBOOK_APP_ID @"336659556437685"
#endif

#endif
