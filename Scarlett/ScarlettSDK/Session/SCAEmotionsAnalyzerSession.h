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
#import "SCAEmotionsAnalyzerSummaryDelegate.h"
#import "SCAEmotionsAnalyzerVoteDelegate.h"
#import "SCAUrlRequest.h"
#import "SCAStartSessionResponder.h"
#import "SCAUpStreamVoiceResponder.h"
#import "SCAAnalysisResponder.h"
#import "SCASummaryResponder.h"
#import "SCAVoteResponder.h"
#import "SCAStartSessionResult.h"
#import "SCAAnalysisResult.h"
#import "SCAStreamPostManager.h"
#import "SCAEmotionAnalysisHosts.h"

@interface SCAEmotionsAnalyzerSession : NSObject<SCAStartSessionResponderDelegate,
                                                 SCAUpStreamVoiceResponderDelegate,
                                                 SCAAnalysisResponderDelegate,
                                                 SCASummaryResponderDelegate,
                                                 SCAVoteResponderDelegate>
{
    SCASessionParameters *_sessionParameters;
    NSString *_apiKey;
    SCAFollowupActions *_actions;
    SCAStartSessionResult *_startSessionResult;
    SCAAnalysisResult *_lastAnalysisResult;
    BOOL _sessionStarted;
    BOOL _getAnalysisInProgress;
}

@property (nonatomic, weak) id<SCAEmotionsAnalyzerSessionDelegate> sessionDelegate;
@property (nonatomic, weak) id<SCAEmotionsAnalyzerSummaryDelegate> summaryDelegate;
@property (nonatomic, weak) id<SCAEmotionsAnalyzerVoteDelegate> voteDelegate;
@property (nonatomic, strong) SCAStartSessionResponder *startSessionResponder;
@property (nonatomic, strong) SCAUpStreamVoiceResponder *upStreamVoiceResponder;
@property (nonatomic, strong) SCAAnalysisResponder *analysisResponder;
@property (nonatomic, strong) SCASummaryResponder *summaryResponder;
@property (nonatomic, strong) SCAVoteResponder *voteResponder;
@property (nonatomic, strong) SCAStreamPostManager *streamPostManager;
@property (nonatomic) NSTimeInterval requestTimeout;
@property (nonatomic) NSTimeInterval getAnalysisTimeInterval;
@property (nonatomic, strong) NSTimer *getAnalysisTimer;
@property (nonatomic, strong) NSString *host;

-(id)initWithSessionParameters:(SCASessionParameters*)sessionParameters
                        apiKey:(NSString*)apiKey
                requestTimeout:(NSTimeInterval)requestTimeout
       getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
                          host:(NSString*)host
               sessionDelegate:(id<SCAEmotionsAnalyzerSessionDelegate>)sessionDelegate;

-(void)startSession;
-(void)stopSession;
-(void)analyzeVoiceData:(NSData*)voiceData;
-(void)analyzeInputStream:(NSInputStream*)inputStream;
-(void)getSummary:(id<SCAEmotionsAnalyzerSummaryDelegate>)summaryDelegate;
-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore;
-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore verbalVote:(NSString*)verbalVote;
-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore verbalVote:(NSString*)verbalVote segment:(SCASegment*)segment;

@end
