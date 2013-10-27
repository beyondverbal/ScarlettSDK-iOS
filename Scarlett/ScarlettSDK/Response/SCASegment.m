//
//  SCASegment.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCASegment.h"

@implementation SCASegment

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        self.duration = [[dictionary objectForKey:@"duration"] unsignedLongValue];
        self.offset = [[dictionary objectForKey:@"offset"] unsignedLongValue];
        self.analysis = [[SCAAnalysisCollection alloc] initWithDictionary:[dictionary objectForKey:@"analysis"]];
    }
    return self;
}

@end
