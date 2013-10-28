//
//  SCARequiredAnalysis.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const SCARequiredAnalysisTemperValue;
extern NSString* const SCARequiredAnalysisTemperMeter;
extern NSString* const SCARequiredAnalysisComposureMeter;
extern NSString* const SCARequiredAnalysisCooperationLevel;
extern NSString* const SCARequiredAnalysisServiceScore;
extern NSString* const SCARequiredAnalysisCompositMood;
extern NSString* const SCARequiredAnalysisMoodGroup;
extern NSString* const SCARequiredAnalysisMoodGroupSummary;

@interface SCARequiredAnalysis : NSObject

@property (nonatomic, retain) NSArray *requiredAnalisys;

-(id)initWithRequiredAnalysis:(NSArray*)requiredAnalysis;

@end
