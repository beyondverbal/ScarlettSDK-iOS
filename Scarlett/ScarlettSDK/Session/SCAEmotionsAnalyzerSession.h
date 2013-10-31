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
@property (nonatomic) BOOL isDebug;

/**
 * Method name: initWithSessionParameters
 * Description: Initialize emotion analyzer session
 * Parameters:  sessionParameters - session parameters such audio data format, recorder info and required analysis types
 *              apiKey - api key
 *              requestTimeout - timeout for the url requests such get analysis, summary request and vote request
 *              getAnalysisTimeInterval - interval to wait between each get analysis request
 *              host - kEmotionAnalysisHostBeta or kEmotionAnalysisHostProduction
 *              isDebug - write to NSLog when isDebug = YES
 *              sessionDelegate - delegate object that responds to session events
 */
-(id)initWithSessionParameters:(SCASessionParameters*)sessionParameters
                        apiKey:(NSString*)apiKey
                requestTimeout:(NSTimeInterval)requestTimeout
       getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
                          host:(NSString*)host
                       isDebug:(BOOL)isDebug
               sessionDelegate:(id<SCAEmotionsAnalyzerSessionDelegate>)sessionDelegate;

/**
 * Method name: startSession
 * Description: Starts the session
 */
-(void)startSession;

/**
 * Method name: stopSession
 * Description: Stops the session (call this function when finished streaming voice data)
 */
-(void)stopSession;

/**
 * Method name: analyzeVoiceData
 * Description: Stream voice data to server
 * Parameters:  voiceData - coice data to stream
 */
-(void)analyzeVoiceData:(NSData*)voiceData;

/**
 * Method name: analyzeInputStream
 * Description: Stream file via input stream
 * Parameters:  inputStream - input stream (can be used to stream from file)
 */
-(void)analyzeInputStream:(NSInputStream*)inputStream;

/**
 * Method name: getSummary
 * Description: Get summary for the analysis
 * Parameters:  summaryDelegate - delegate object that responds to summary events
 */
-(void)getSummary:(id<SCAEmotionsAnalyzerSummaryDelegate>)summaryDelegate;

/**
 * Method name: vote
 * Description: Vote for the analysis
 * Parameters:  voteDelegate - delegate object that responds to vote events
 *              voteScore - voting score (0 - wrong analysis, 1 - correct analysis
 */
-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore;

/**
 * Method name: vote
 * Description: Vote for the analysis
 * Parameters:  voteDelegate - delegate object that responds to vote events
 *              voteScore - voting score (0 - wrong analysis, 1 - correct analysis
 *              verbalVote - verbal text
 */
-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore verbalVote:(NSString*)verbalVote;

/**
 * Method name: vote
 * Description: Vote for the analysis
 * Parameters:  voteDelegate - delegate object that responds to vote events
 *              voteScore - voting score (0 - wrong analysis, 1 - correct analysis
 *              verbalVote - verbal text
 *              segment - analysis segment that you vote about
 */
-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore verbalVote:(NSString*)verbalVote segment:(SCASegment*)segment;

@end
