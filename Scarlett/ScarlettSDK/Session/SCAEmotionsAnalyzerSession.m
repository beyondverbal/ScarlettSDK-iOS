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
                      delegate:(id<SCAEmotionsAnalyzerSessionDelegate>)delegate
{
    if(self = [super init])
    {
        self.delegate = delegate;
        
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
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[_sessionParameters recorderInfoToDictionary] forKey:@"recorder_info"];
    [dictionary setObject:[_sessionParameters dataFormatToDictionary] forKey:@"data_format"];
    [dictionary setObject:[_sessionParameters requiredAnalysisTypesArray] forKey:@"requiredAnalysisTypes"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString =[[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString: %@", jsonString);
    
    SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:SCAStartSessionUrlFormat, self.host, _apiKey];
    
    [request loadWithUrl:url body:bodyData timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"POST" delegate:self.startSessionResponder];
}

-(void)stopSession
{
    [self stopStreamPostManager];
    
    [self stopAnalysisTimer];
    
    _lastAnalysisResult = nil;
}

-(void)upStreamVoiceData:(NSData*)voiceData
{
    if(!self.streamPostManager)
    {
        self.streamPostManager = [[SCAStreamPostManager alloc] initWithDelegate:self.upStreamVoiceResponder];
        
        [self.streamPostManager startSend:_startSessionResult.followupActions.upStream];
        
        [self startAnalysisTimer];
    }
    
    [self.streamPostManager appendPostData:voiceData];
}

-(void)getSummary:(SCAAnalysisResult*)analysisResults
{
    SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
    
    NSString *url = analysisResults.followupActions.summary;
    
    [request loadWithUrl:url body:nil timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"GET" delegate:self.];
}

-(void)vote:(SCAAnalysisResult*)analysisResults
{
    SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
    
    NSString *url = analysisResults.followupActions.vote;
    
    [request loadWithUrl:url body:nil timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"GET" delegate:self.];
}

#pragma mark - Response

-(void)startSessionSucceed:(NSData *)responseData
{
    _startSessionResult = [[SCAStartSessionResult alloc] initWithResponseData:responseData];
    
    if([_startSessionResult isSucceed])
    {
        [self.delegate startSessionSucceed];
    }
    else
    {
        [self.delegate startSessionFailed:_startSessionResult.reason];
    }
}

-(void)startSessionFailed:(NSError*)error
{
    [self.delegate startSessionFailed:[error localizedDescription]];
}

-(void)upStreamVoiceSucceed:(NSData *)responseData
{
    //TODO: parse response
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"upStreamVoiceSucceed %@", jsonObject);
    
    [self.delegate upStreamVoiceDataSucceed];
}

-(void)upStreamVoiceFailed:(NSString *)errorDescription
{
    NSLog(@"upStreamVoiceFailed %@", errorDescription);
    
    [self.delegate upStreamVoiceDataFailed:errorDescription];
}

-(void)getAnalysisSucceed:(NSData *)responseData
{
    _lastAnalysisResult = [[SCAAnalysisResult alloc] initWithResponseData:responseData];
    
    if([_lastAnalysisResult isSessionStatusDone])
    {
        [self stopSession];
    }
    
    [self.delegate getAnalysisSucceed:_lastAnalysisResult];
}

-(void)getAnalysisFailed:(NSError *)error
{
    NSLog(@"analysisFailed %@", [error localizedDescription]);
    
    [self.delegate getAnalysisFailed:[error localizedDescription]];
}

-(void)getSummarySucceed:(NSData *)responseData
{
    
}

-(void)getSummaryFailed:(NSError *)error
{
    
}

-(void)voteSucceed:(NSData *)responseData
{
    
}

-(void)voteFailed:(NSError *)error
{
    
}

#pragma mark - Private methods

-(void)getAnalysisExecute:(NSTimer *)timer
{
    [self getAnalysis];
}

-(void)getAnalysis
{    
    SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
    
    NSString *url = _startSessionResult.followupActions.analysis;
    
    if(_lastAnalysisResult)
    {
        url = _lastAnalysisResult.followupActions.analysis;
    }
    
    NSLog(@"getAnalysis %@", url);
    
    [request loadWithUrl:url body:nil timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"GET" delegate:self.analysisResponder];
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
