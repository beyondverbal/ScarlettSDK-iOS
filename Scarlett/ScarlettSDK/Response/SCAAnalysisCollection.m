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
        self.temperValue = [[SCAFloatAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"TemperValue"]];
        self.composureMeter = [[SCAFloatAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"ComposureMeter"]];
        self.temperMeter = [[SCAStringAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"TemperMeter"]];
        self.compositMood = [[SCACompositStringAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"CompositMood"]];
        self.moodGroup = [[SCACompositStringAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"MetaGroup"]];
    }
    return self;
}

@end
