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
{
    NSString *_apiKey;
    NSTimeInterval _requestTimeout;
    NSTimeInterval _getAnalysisTimeInterval;
    NSString *_host;
    id<SCAEmotionsAnalyzerSessionDelegate> _delegate;
}

-(id)initWithApiKey:(NSString*)apiKey
     requestTimeout:(NSTimeInterval)requestTimeout
getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
               host:(NSString*)host
           delegate:(id<SCAEmotionsAnalyzerSessionDelegate>)delegate;

-(SCAEmotionsAnalyzerSession*)initializeSession:(SCASessionParameters*)sessionParameters;

@end
