//
//  SCAFollowupActions.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAFollowupActions.h"

@implementation SCAFollowupActions

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        self.analysis = [dictionary objectForKey:@"analysis"];
        self.summary = [dictionary objectForKey:@"summary"];
        self.upStream = [dictionary objectForKey:@"upStream"];
    }
    return self;
}

@end
