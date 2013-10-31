//
//  VoiceDataStreamer.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/30/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "VoiceDataStreamer.h"

@implementation VoiceDataStreamer

NSString* const kUpStreamVoiceDataNotification = @"UpStreamVoiceDataNotification";
NSString* const kUpStreamVoiceDataKey = @"UpStreamVoiceDataKey";

-(id)initWithEmotionsAnalyzerSession:(SCAEmotionsAnalyzerSession*)emotionsAnalyzerSession collectedVoiceDataIntervalMilliseconds:(float)collectedVoiceDataIntervalMilliseconds
{
    if(self = [super init])
    {
        _emotionsAnalyzerSession = emotionsAnalyzerSession;
        _collectedVoiceDataIntervalMilliseconds = collectedVoiceDataIntervalMilliseconds;
        _collectedVoiceData = [[NSMutableData alloc] init];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpStreamVoiceDataKey object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(upStreamVoiceDataNotification:)
                                                     name:kUpStreamVoiceDataNotification
                                                   object:nil];
    }
    return self;
}

-(void)upStreamVoiceDataNotification:(NSNotification*)notification
{
    NSData *voiceData = [notification.userInfo objectForKey:kUpStreamVoiceDataKey];
    
    [_collectedVoiceData appendData:voiceData];
    
    if(_collectedVoiceDataMilliseconds > 0)
    {
        float currentMillisecond = [SCAMillisecondsUtils getMilliseconds];
        
        if(currentMillisecond - _collectedVoiceDataMilliseconds >= _collectedVoiceDataIntervalMilliseconds)
        {
            _collectedVoiceDataMilliseconds = [SCAMillisecondsUtils getMilliseconds];
            
            NSData *newVoiceData = [NSData dataWithData:_collectedVoiceData];
            
            [_emotionsAnalyzerSession analyzeVoiceData:newVoiceData];
            
            _collectedVoiceData = [[NSMutableData alloc] init];
        }
    }
    else
    {
        _collectedVoiceDataMilliseconds = [SCAMillisecondsUtils getMilliseconds];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
