//
//  EmotionsAnalyzer.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/28/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAEmotionsAnalyzer.h"

NSString* const kScarlettPlistFileName = @"Scarlett-Info.plist";
NSString* const kScarlettPlistApiKeyName = @"ScarlettApiKey";

@implementation SCAEmotionsAnalyzer

+(SCAEmotionsAnalyzerSession*)initializeSession:(SCASessionParameters*)sessionParameters
                                         apiKey:(NSString*)apiKey
                                 requestTimeout:(NSTimeInterval)requestTimeout
                        getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
                                           host:(NSString*)host
                                sessionDelegate:(id<SCAEmotionsAnalyzerSessionDelegate>)sessionDelegate
{
    NSString *currentApiKey = apiKey;
    
    if(!currentApiKey)
    {
        currentApiKey = [SCAEmotionsAnalyzer readApiKeyFromPlist];
    }
    
    SCAEmotionsAnalyzerSession *emotionsAnalyzerSession = [[SCAEmotionsAnalyzerSession alloc] initWithSessionParameters:sessionParameters apiKey:currentApiKey requestTimeout:requestTimeout getAnalysisTimeInterval:getAnalysisTimeInterval host:host sessionDelegate:sessionDelegate];
    
    return emotionsAnalyzerSession;
}

+(NSString*)readApiKeyFromPlist
{
    // read api key from plist ScarlettApiKey
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:kScarlettPlistFileName ofType:nil];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    
    NSString *apiKey = [dictionary objectForKey:kScarlettPlistApiKeyName];
    
    return apiKey;
}

@end
