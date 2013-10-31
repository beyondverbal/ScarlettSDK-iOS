//
//  VoiceRecorder.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/30/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "VoiceRecorder.h"

void AudioInputCallback(void * inUserData,
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp * inStartTime,
                        UInt32 inNumberPacketDescriptions,
                        const AudioStreamPacketDescription * inPacketDescs);

@implementation VoiceRecorder

// Takes a filled buffer and writes it to disk, "emptying" the buffer
void AudioInputCallback(void * inUserData,
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp * inStartTime,
                        UInt32 inNumberPacketDescriptions,
                        const AudioStreamPacketDescription * inPacketDescs)
{
	RecordState * recordState = (RecordState*)inUserData;
    
    if (!recordState->recording)
    {
        return;
    }
    
    NSData *data = [NSData dataWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:data forKey:kUpStreamVoiceDataKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpStreamVoiceDataNotification object:nil userInfo:userInfo];
    
    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
}

-(BOOL)isRecording
{
    return (recordState.recording == true);
}

- (void)setupAudioFormat:(AudioStreamBasicDescription*)format streamingVoiceData:(BOOL)streamingVoiceData
{
	format->mSampleRate = 8000.0;
    
    if(streamingVoiceData)
    {
        format->mFormatID = kAudioFormatLinearPCM;
    }
    else
    {
        format->mFormatID = kAudioFormatULaw;
    }
	format->mFramesPerPacket = 1;
	format->mChannelsPerFrame = 1;
	format->mBytesPerFrame = 2;
	format->mBytesPerPacket = 2;
	format->mBitsPerChannel = 16;
	format->mReserved = 0;
	format->mFormatFlags = kLinearPCMFormatFlagIsBigEndian     |
    kLinearPCMFormatFlagIsSignedInteger |
    kLinearPCMFormatFlagIsPacked;
}

-(BOOL)startRecording:(BOOL)streamingVoiceData
{
    // Init state variables
    recordState.recording = false;
    
    [self setupAudioFormat:&recordState.dataFormat streamingVoiceData:streamingVoiceData];
    
    recordState.currentPacket = 0;
	
    OSStatus status;
    status = AudioQueueNewInput(&recordState.dataFormat,
                                AudioInputCallback,
                                &recordState,
                                CFRunLoopGetCurrent(),
                                kCFRunLoopCommonModes,
                                0,
                                &recordState.queue);
    
    if (status == 0)
    {
        // Prime recording buffers with empty data
        for (int i = 0; i < NUM_BUFFERS; i++)
        {
            AudioQueueAllocateBuffer(recordState.queue, 16000, &recordState.buffers[i]);
            AudioQueueEnqueueBuffer (recordState.queue, recordState.buffers[i], 0, NULL);
        }
        
        recordState.recording = true;
        status = AudioQueueStart(recordState.queue, NULL);
    }
    
    if (status != 0)
    {
        [self stopRecording];
        
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)stopRecording
{
    if(recordState.recording)
    {
        recordState.recording = false;
        
        AudioQueueStop(recordState.queue, true);
        for(int i = 0; i < NUM_BUFFERS; i++)
        {
            AudioQueueFreeBuffer(recordState.queue, recordState.buffers[i]);
        }
        
        AudioQueueDispose(recordState.queue, true);
    }
}

@end
