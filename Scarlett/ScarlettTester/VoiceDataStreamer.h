//
//  VoiceDataStreamer.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/30/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAEmotionsAnalyzerSession.h"
#import "SCAMillisecondsUtils.h"

extern NSString* const kUpStreamVoiceDataNotification;
extern NSString* const kUpStreamVoiceDataKey;

@interface VoiceDataStreamer : NSObject
{
    SCAEmotionsAnalyzerSession *_emotionsAnalyzerSession;
    NSMutableData *_collectedVoiceData;
    float _collectedVoiceDataIntervalMilliseconds;
    float _collectedVoiceDataMilliseconds;
}

/**
 * Method name: initWithEmotionsAnalyzerSession
 * Description: Initialize voice streamer
 * Parameters:  emotionsAnalyzerSession - current analysis session
 *              collectedVoiceDataIntervalMilliseconds - time interval to send collected voice data to server
 */
-(id)initWithEmotionsAnalyzerSession:(SCAEmotionsAnalyzerSession*)emotionsAnalyzerSession collectedVoiceDataIntervalMilliseconds:(float)collectedVoiceDataIntervalMilliseconds;

@end
