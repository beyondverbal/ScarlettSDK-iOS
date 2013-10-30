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
#import "DetailsViewController.h"
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

@interface MainViewController : UIViewController<SCAEmotionsAnalyzerSessionDelegate, UITableViewDataSource, UITableViewDelegate>
{
    RecordState recordState;
}

@property (nonatomic, strong) IBOutlet UIButton *btnStartStopSession;
@property (nonatomic, strong) IBOutlet UIButton *btnSendSampleFile;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) IBOutlet UITableView *tblAnalysisList;

@property (nonatomic) BOOL sessionStarted;
@property (nonatomic) BOOL streamingVoiceData;
@property (nonatomic, strong) SCAEmotionsAnalyzerSession *emotionsAnalyzerSession;
@property (nonatomic, strong) NSMutableArray *analysisSegments;
@property (nonatomic, strong) VoiceDataStreamer *voiceDataStreamer;

-(IBAction)btnStartStopSession_Pressed:(id)sender;
-(IBAction)btnSendSampleFile_Pressed:(id)sender;

@end
