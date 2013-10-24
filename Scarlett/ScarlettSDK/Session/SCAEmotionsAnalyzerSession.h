//
//  SCAEmotionsAnalyzerSession.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCASessionParameters.h"
#import "SCAFollowupActions.h"
#import "SCAEmotionsAnalyzerSessionDelegate.h"
#import "SCAUrlRequest.h"
#import "SCAStartSessionResponder.h"
#import "SCAUpStreamVoiceResponder.h"
#import "SCAAnalysisResponder.h"
#import "SCAStartSessionResult.h"
#import "SCAStreamPostManager.h"

@interface SCAEmotionsAnalyzerSession : NSObject<SCAStartSessionResponderDelegate, SCAUpStreamVoiceResponderDelegate, SCAAnalysisResponderDelegate>
{
    SCASessionParameters *_sessionParameters;
    NSString *_apiKey;
    SCAFollowupActions *_actions;
    SCAStartSessionResult *_startSessionResult;
}

@property (nonatomic, weak) id<SCAEmotionsAnalyzerSessionDelegate> delegate;
@property (nonatomic, strong) SCAStartSessionResponder *startSessionResponder;
@property (nonatomic, strong) SCAUpStreamVoiceResponder *upStreamVoiceResponder;
@property (nonatomic, strong) SCAAnalysisResponder *analysisResponder;
@property (nonatomic, strong) SCAStreamPostManager *streamPostManager;
@property (nonatomic) NSTimeInterval timeoutInterval;

-(id)initWithSessionParameters:(SCASessionParameters*)sessionParameters
                        apiKey:(NSString*)apiKey
               timeoutInterval:(NSTimeInterval)timeoutInterval
                      delegate:(id<SCAEmotionsAnalyzerSessionDelegate>)delegate;
-(void)startSession;
-(void)stopSession;
-(void)upStreamVoiceData:(NSData*)voiceData;
-(void)getAnalysis;
-(void)vote;

@end
