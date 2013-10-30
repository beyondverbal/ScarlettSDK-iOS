//
//  EmotionsAnalyzer.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/28/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCASessionParameters.h"
#import "SCAEmotionsAnalyzerSessionDelegate.h"
#import "SCAEmotionsAnalyzerSession.h"

@interface SCAEmotionsAnalyzer : NSObject

+(SCAEmotionsAnalyzerSession*)initializeSession:(SCASessionParameters*)sessionParameters
                                         apiKey:(NSString*)apiKey
                                 requestTimeout:(NSTimeInterval)requestTimeout
                        getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
                                           host:(NSString*)host
                                sessionDelegate:(id<SCAEmotionsAnalyzerSessionDelegate>)sessionDelegate;

@end
