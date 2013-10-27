//
//  SCAEmotionsAnalyzerSession.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAEmotionsAnalyzerSession.h"

//NSString* const SCAStartSessionUrlFormat = @"https://beta.beyondverbal.com/v1/recording/start?api_key=%@";
NSString* const SCAStartSessionUrlFormat = @"http://172.16.10.139/v1/recording/start?api_key=%@";

@implementation SCAEmotionsAnalyzerSession

-(id)initWithSessionParameters:(SCASessionParameters*)sessionParameters
                        apiKey:(NSString*)apiKey
                requestTimeout:(NSTimeInterval)requestTimeout
       getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
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
        
        _sessionParameters = sessionParameters;
        _apiKey = apiKey;
        
        self.requestTimeout = requestTimeout;
        self.getAnalysisTimeInterval = getAnalysisTimeInterval;
    }
    return self;
}

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
    
    NSString *url = [NSString stringWithFormat:SCAStartSessionUrlFormat, _apiKey];
    
    [request loadWithUrl:url body:bodyData timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"POST" delegate:self.startSessionResponder];
}

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

-(void)stopSession
{
    [self.streamPostManager stopSend];
    
    self.streamPostManager = nil;
    
    [self.getAnalysisTimer invalidate];
    
    self.getAnalysisTimer = nil;
}

-(void)upStreamVoiceData:(NSData*)voiceData
{
    if(!self.streamPostManager)
    {
        self.streamPostManager = [[SCAStreamPostManager alloc] initWithDelegate:self.upStreamVoiceResponder];
        
        [self.streamPostManager startSend:_startSessionResult.followupActions.upStream];
        
        self.getAnalysisTimer = [NSTimer scheduledTimerWithTimeInterval:self.getAnalysisTimeInterval
                                                                 target:self
                                                               selector:@selector(getAnalysisExecute:)
                                                               userInfo:nil
                                                                repeats:YES];
    }
    
    [self.streamPostManager appendPostData:voiceData];
}

-(void)getAnalysisExecute:(NSTimer *)timer
{
    [self getAnalysis];
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

-(void)getAnalysis
{    
    SCAUrlRequest *request = [[SCAUrlRequest alloc] init];
    
    NSString *url = _startSessionResult.followupActions.analysis;
    
    NSLog(@"getAnalysis %@", url);
    
    [request loadWithUrl:url body:nil timeoutInterval:self.requestTimeout isStream:NO httpMethod:@"GET" delegate:self.analysisResponder];
}

-(void)getAnalysisSucceed:(NSData *)responseData
{
    //TODO: parse response
    SCAAnalysisResult *analysisResult = [[SCAAnalysisResult alloc] initWithResponseData:responseData];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"analysisSucceed %@", jsonObject);
    
    [self.delegate getAnalysisSucceed:analysisResult];
}

-(void)getAnalysisFailed:(NSError *)error
{
    NSLog(@"analysisFailed %@", [error localizedDescription]);
    
    [self.delegate getAnalysisFailed:[error localizedDescription]];
}

@end
