//
//  SCARequiredAnalysis.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCARequiredAnalysis.h"

NSString* const SCARequiredAnalysisTemperValue = @"TemperValue";
NSString* const SCARequiredAnalysisTemperMeter = @"TemperMeter";
NSString* const SCARequiredAnalysisComposureMeter = @"ComposureMeter";
NSString* const SCARequiredAnalysisCooperationLevel = @"CooperationLevel";
NSString* const SCARequiredAnalysisServiceScore = @"ServiceScore";
NSString* const SCARequiredAnalysisCompositMood = @"CompositMood";
NSString* const SCARequiredAnalysisMoodGroup = @"MoodGroup";
NSString* const SCARequiredAnalysisMoodGroupSummary = @"MoodGroupSummary";

@implementation SCARequiredAnalysis

-(id)initWithRequiredAnalysis:(NSArray*)requiredAnalysis
{
    if(self = [super init])
    {
        self.requiredAnalisys = requiredAnalysis;
    }
    return self;
}

@end
