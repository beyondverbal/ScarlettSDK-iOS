//
//  ViewController.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>

#import "SCAEmotionsAnalyzerSession.h"
#import "SCAPcmDataFormat.h"
#import "SCAWavDataFormat.h"
#import "SCAMillisecondsUtils.h"

#define NUM_BUFFERS 3
//#define SECONDS_TO_RECORD 10

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

// Struct defining playback state
typedef struct
{
    AudioStreamBasicDescription  dataFormat;
    AudioQueueRef                queue;
    AudioQueueBufferRef          buffers[NUM_BUFFERS];
    AudioFileID                  audioFile;
    SInt64                       currentPacket;
    bool                         playing;
} PlayState;

@interface ViewController : UIViewController<SCAEmotionsAnalyzerSessionDelegate>
{
    RecordState recordState;
    PlayState playState;
    CFURLRef fileURL;
    float collectedVoiceDataMilliseconds;
}

@property (nonatomic, strong) SCAEmotionsAnalyzerSession *emotionsAnalyzerSession;
@property (nonatomic, strong) IBOutlet UILabel *labelStatus;
@property (nonatomic, strong) NSMutableData *collectedVoiceData;

-(IBAction)startSessionClicked:(id)sender;
-(IBAction)stopSessionClicked:(id)sender;
-(IBAction)sendFileClicked:(id)sender;
-(IBAction)startRecordingClicked:(id)sender;
-(IBAction)stopRecordingClicked:(id)sender;
-(IBAction)startPlayingClicked:(id)sender;
-(IBAction)stopPlayingClicked:(id)sender;
-(IBAction)sendRecordedFileClicked:(id)sender;
-(IBAction)sendCollectedVoiceDataClicked:(id)sender;
-(IBAction)compareFileWithCollectedDataClicked:(id)sender;


@end
