//
//  SCASummaryCollection.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/29/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCASummaryCollection.h"

@implementation SCASummaryCollection

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        if([dictionary objectForKey:@"MoodGroupSummary"])
        {
            self.moodGroupSummary = [[SCACompositStringAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"MoodGroupSummary"]];
        }
    }
    return self;
}

@end
