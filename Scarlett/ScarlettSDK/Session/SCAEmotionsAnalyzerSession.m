//
//  SCAEmotionsAnalyzerSession.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAEmotionsAnalyzerSession.h"

NSString* const SCAStartSessionUrlFormat = @"https://%@/v1/recording/start?api_key=%@";

@implementation SCAEmotionsAnalyzerSession

-(id)initWithSessionParameters:(SCASessionParameters*)sessionParameters
                        apiKey:(NSString*)apiKey
                requestTimeout:(NSTimeInterval)requestTimeout
       getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
                          host:(NSString*)host
               sessionDelegate:(id<SCAEmotionsAnalyzerSessionDelegate>)sessionDelegate
{
    if(self = [super init])
    {
        self.sessionDelegate = sessionDelegate;
        
        self.startSessionResponder = [[SCAStartSessionResponder alloc] init];
        self.startSessionResponder.delegate = self;
        self.upStreamVoiceResponder = [[SCAUpStreamVoiceResponder alloc] init];
        self.upStreamVoiceResponder.delegate = self;
        self.analysisResponder = [[SCAAnalysisResponder alloc] init];
        self.analysisResponder.delegate = self;
        self.summaryResponder = [[SCASummaryResponder alloc] init];
        self.summaryResponder.delegate = self;
        self.voteResponder = [[SCAVoteResponder alloc] init];
        self.voteResponder.delegate = self;
        
        _sessionParameters = sessionParameters;
        _apiKey = apiKey;
        
        self.requestTimeout = requestTimeout;
        self.getAnalysisTimeInterval = getAnalysisTimeInterval;
        self.host = host;
    }
    return self;
}

#pragma mark - Public methods

-(void)startSession
{
    _sessionStarted = YES;
    _lastAnalysisResult = nil;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[_sessionParameters recorderInfoToDictionary] forKey:@"recorder_info"];
    [dictionary setObject:[_sessionParameters dataFormatToDictionary] forKey:@"data_format"];
    [dictionary setObject:[_sessionParameters requiredAnalysisTypesArray] forKey:@"requiredAnalysisTypes"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString =[[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    NSLog(@"startSession %@", jsonString);
    
    SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:SCAStartSessionUrlFormat, self.host, _apiKey];
    
    [request loadWithUrl:url body:bodyData timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"POST" delegate:self.startSessionResponder];
}

-(void)stopSession
{
    _sessionStarted = NO;
    
    [self stopStreamPostManager];
}

-(void)analyzeVoiceData:(NSData*)voiceData
{
    if(_sessionStarted)
    {
        if(!self.streamPostManager)
        {
            self.streamPostManager = [[SCAStreamPostManager alloc] initWithDelegate:self.upStreamVoiceResponder requestTimeout:self.requestTimeout];
            
            [self.streamPostManager startSend:_startSessionResult.followupActions.upStream];
        }
        
        [self.streamPostManager appendPostData:voiceData];
        
        if(!self.getAnalysisTimer)
        {
            [self startAnalysisTimer];
        }
    }
}

-(void)analyzeInputStream:(NSInputStream*)inputStream
{
    if(_sessionStarted)
    {
        if(!self.streamPostManager)
        {
            self.streamPostManager = [[SCAStreamPostManager alloc] initWithDelegate:self.upStreamVoiceResponder requestTimeout:self.requestTimeout];
            
            [self.streamPostManager startSend:_startSessionResult.followupActions.upStream inputStream:inputStream];
        }
        
        if(!self.getAnalysisTimer)
        {
            [self startAnalysisTimer];
        }
    }
}

-(void)getSummary:(id<SCAEmotionsAnalyzerSummaryDelegate>)summaryDelegate
{
    self.summaryDelegate = summaryDelegate;
    
    if(_lastAnalysisResult)
    {
        SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
        
        NSString *url = _lastAnalysisResult.followupActions.summary;
        
        [request loadWithUrl:url body:nil timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"GET" delegate:self.summaryResponder];
    }
    else
    {
        [self.summaryDelegate getSummaryFailed:@"Must recieve at least one analysis"];
    }
}

-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore
{
    [self vote:voteDelegate voteScore:voteScore verbalVote:nil];
}

-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore verbalVote:(NSString*)verbalVote
{
    [self vote:voteDelegate voteScore:voteScore verbalVote:verbalVote segment:nil];
}

-(void)vote:(id<SCAEmotionsAnalyzerVoteDelegate>)voteDelegate voteScore:(int)voteScore verbalVote:(NSString*)verbalVote segment:(SCASegment*)segment
{
    self.voteDelegate = voteDelegate;
    
    if(_lastAnalysisResult)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        if(segment)
        {
            [dictionary setObject:[NSNumber numberWithUnsignedLong:segment.offset] forKey:@"offset"];
            [dictionary setObject:[NSNumber numberWithUnsignedLong:segment.duration] forKey:@"duration"];
        }
        
        [dictionary setObject:[NSNumber numberWithInt:voteScore] forKey:@"vote"];
        
        if(verbalVote)
        {
            [dictionary setObject:verbalVote forKey:@"verbalVote"];
        }
        
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *jsonString =[[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
        
        NSLog(@"vote %@", jsonString);
        
        SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
        
        NSString *url = _lastAnalysisResult.followupActions.vote;
        
        [request loadWithUrl:url body:bodyData timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"POST" delegate:self.voteResponder];
    }
    else
    {
        [self.voteDelegate voteFailed:@"Must recieve at least one analysis"];
    }
}

#pragma mark - Response

-(void)startSessionSucceed:(NSData *)responseData
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"startSessionSucceed %@", jsonObject);
    
    _startSessionResult = [[SCAStartSessionResult alloc] initWithResponseData:responseData];
    
    if([_startSessionResult isSucceed])
    {
        [self.sessionDelegate startSessionSucceed];
    }
    else
    {
        [self.sessionDelegate startSessionFailed:_startSessionResult.reason];
    }
}

-(void)startSessionFailed:(NSError*)error
{
    [self.sessionDelegate startSessionFailed:[error localizedDescription]];
}

-(void)upStreamVoiceSucceed:(NSData *)responseData
{
    //TODO: parse response
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"upStreamVoiceSucceed %@", jsonObject);
    
    [self stopSession];
    
    [self.sessionDelegate processingDone];
}

-(void)upStreamVoiceFailed:(NSString *)errorDescription
{
    NSLog(@"upStreamVoiceFailed %@", errorDescription);
    
    [self stopSession];
    
    [self.sessionDelegate processingDone];
}

-(void)upStreamVoiceStopped
{
    NSLog(@"upStreamVoiceStopped");
    
    [self stopSession];
    
    [self.sessionDelegate processingDone];
}

-(void)getAnalysisSucceed:(NSData *)responseData
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"getAnalysisSucceed %@", jsonObject);
    
    _lastAnalysisResult = [[SCAAnalysisResult alloc] initWithResponseData:responseData];
    
    if([_lastAnalysisResult isSessionStatusDone])
    {
        [self stopSession];
        
        [self stopAnalysisTimer];
    }
    
    [self.sessionDelegate newAnalysis:_lastAnalysisResult];
    
    _getAnalysisInProgress = NO;
}

-(void)getAnalysisFailed:(NSError *)error
{
    NSLog(@"analysisFailed %@", [error localizedDescription]);
        
    _getAnalysisInProgress = NO;
}

-(void)getSummarySucceed:(NSData *)responseData
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"getSummarySucceed %@", jsonObject);
    
    SCASummaryResult *summaryResult = [[SCASummaryResult alloc] initWithResponseData:responseData];
    
    [self.summaryDelegate getSummarySucceed:summaryResult];
}

-(void)getSummaryFailed:(NSError *)error
{
    NSLog(@"getSummaryFailed %@", [error localizedDescription]);
    
    [self.summaryDelegate getSummaryFailed:[error localizedDescription]];
}

-(void)voteSucceed:(NSData *)responseData
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"voteSucceed %@", jsonObject);
    
    SCAVoteResult *voteResult = [[SCAVoteResult alloc] initWithResponseData:responseData];
    
    [self.voteDelegate voteSucceed:voteResult];
}

-(void)voteFailed:(NSError *)error
{
    NSLog(@"voteFailed %@", [error localizedDescription]);
    
    [self.voteDelegate voteFailed:[error localizedDescription]];
}

#pragma mark - Private methods

-(void)getAnalysisExecute:(NSTimer *)timer
{
    [self getAnalysis];
}

-(void)getAnalysis
{
    if(!_getAnalysisInProgress)
    {
        _getAnalysisInProgress = YES;
        
        SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
        
        NSString *url = _startSessionResult.followupActions.analysis;
        
        if(_lastAnalysisResult)
        {
            url = _lastAnalysisResult.followupActions.analysis;
        }
        
        NSLog(@"getAnalysis %@", url);
        
        [request loadWithUrl:url body:nil timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"GET" delegate:self.analysisResponder];
    }
}

-(void)startAnalysisTimer
{
    self.getAnalysisTimer = [NSTimer scheduledTimerWithTimeInterval:self.getAnalysisTimeInterval
                                                             target:self
                                                           selector:@selector(getAnalysisExecute:)
                                                           userInfo:nil
                                                            repeats:YES];
}

-(void)stopAnalysisTimer
{
    if(self.getAnalysisTimer)
    {
        [self.getAnalysisTimer invalidate];
    }
    
    self.getAnalysisTimer = nil;
}

-(void)stopStreamPostManager
{
    if(self.streamPostManager)
    {
        [self.streamPostManager stopSend];
    }
    
    self.streamPostManager = nil;
}

@end
