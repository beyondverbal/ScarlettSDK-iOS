//
//  MainViewController.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/28/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//


#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import "SCAEmotionsAnalyzer.h"
#import "SCAPcmDataFormat.h"
#import "SCAWavDataFormat.h"
#import "SCAMillisecondsUtils.h"

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

@interface MainViewController : UIViewController<SCAEmotionsAnalyzerSessionDelegate, UITableViewDataSource, UITableViewDelegate>
{
    RecordState recordState;
    PlayState playState;
    CFURLRef fileURL;
    float collectedVoiceDataMilliseconds;
}

@property (nonatomic, strong) IBOutlet UIButton *btnStartStopSession;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) IBOutlet UITableView *tblAnalysisList;

@property (nonatomic) BOOL sessionStarted;
@property (nonatomic, strong) SCAEmotionsAnalyzer *emotionsAnalyzer;
@property (nonatomic, strong) SCAEmotionsAnalyzerSession *emotionsAnalyzerSession;
@property (nonatomic, strong) NSMutableData *collectedVoiceData;
@property (nonatomic, strong) NSMutableArray *analysisSegments;

-(IBAction)btnStartStopSession_Pressed:(id)sender;

@end
