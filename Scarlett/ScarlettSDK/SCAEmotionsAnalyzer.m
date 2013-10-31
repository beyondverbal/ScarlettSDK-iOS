//
//  EmotionsAnalyzer.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/28/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAEmotionsAnalyzer.h"

NSString* const kScarlettPlistApiKeyName = @"ScarlettApiKey";

@implementation SCAEmotionsAnalyzer

+(SCAEmotionsAnalyzerSession*)initializeSession:(SCASessionParameters*)sessionParameters
                                         apiKey:(NSString*)apiKey
                                  plistFileName:(NSString*)plistFileName
                                 requestTimeout:(NSTimeInterval)requestTimeout
                        getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
                                           host:(NSString*)host
                                        isDebug:(BOOL)isDebug
                                sessionDelegate:(id<SCAEmotionsAnalyzerSessionDelegate>)sessionDelegate
{
    NSString *currentApiKey = apiKey;
    
    if(!currentApiKey || [currentApiKey isEqualToString:@""])
    {
        currentApiKey = [SCAEmotionsAnalyzer readApiKeyFromPlist:plistFileName];
    }
    
    SCAEmotionsAnalyzerSession *emotionsAnalyzerSession = [[SCAEmotionsAnalyzerSession alloc] initWithSessionParameters:sessionParameters apiKey:currentApiKey requestTimeout:requestTimeout getAnalysisTimeInterval:getAnalysisTimeInterval host:host isDebug:isDebug sessionDelegate:sessionDelegate];
    
    return emotionsAnalyzerSession;
}

+(NSString*)readApiKeyFromPlist:(NSString*)plistFileName
{
    // read api key from plist ScarlettApiKey
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:plistFileName ofType:nil];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    
    NSString *apiKey = [dictionary objectForKey:kScarlettPlistApiKeyName];
    
    return apiKey;
}

@end
