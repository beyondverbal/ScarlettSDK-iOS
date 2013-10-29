//
//  SCAAnalysisCollection.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAAnalysisCollection.h"

@implementation SCAAnalysisCollection

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        if([dictionary objectForKey:@"TemperValue"])
        {
            self.temperValue = [[SCAFloatAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"TemperValue"]];
        }
        
        if([dictionary objectForKey:@"ComposureMeter"])
        {
            self.composureMeter = [[SCAFloatAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"ComposureMeter"]];
        }
        
        if([dictionary objectForKey:@"TemperMeter"])
        {
            self.temperMeter = [[SCAStringAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"TemperMeter"]];
        }
        
        if([dictionary objectForKey:@"CompositMood"])
        {
            self.compositMood = [[SCACompositStringAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"CompositMood"]];
        }
        
        if([dictionary objectForKey:@"MoodGroup"])
        {
            self.moodGroup = [[SCACompositStringAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"MoodGroup"]];
        }
    }
    return self;
}

@end
