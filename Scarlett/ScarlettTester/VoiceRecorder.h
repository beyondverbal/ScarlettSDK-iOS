//
//  VoiceRecorder.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/30/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import "VoiceDataStreamer.h"

#define NUM_BUFFERS 3

// Struct defining recording state
typedef struct
{
    AudioStreamBasicDescription  dataFormat;
    AudioQueueRef                queue;
    AudioQueueBufferRef          buffers[NUM_BUFFERS];
    AudioFileID                  audioFile;
    SInt64                       currentPacket;
    bool                         recording;
} RecordState;

@interface VoiceRecorder : NSObject
{
    RecordState recordState;
}

-(BOOL)isRecording;
-(BOOL)startRecording:(BOOL)streamingVoiceData;
-(void)stopRecording;

@end
