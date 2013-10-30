//
//  MainViewController.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/28/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAEmotionsAnalyzer.h"
#import "SCAPcmDataFormat.h"
#import "SCAWavDataFormat.h"
#import "SCAMillisecondsUtils.h"
#import "DetailsViewController.h"
#import "VoiceDataStreamer.h"
#import "VoiceRecorder.h"

@interface MainViewController : UIViewController<SCAEmotionsAnalyzerSessionDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *btnStartStopSession;
@property (nonatomic, strong) IBOutlet UIButton *btnSendSampleFile;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) IBOutlet UITableView *tblAnalysisList;

@property (nonatomic) BOOL sessionStarted;
@property (nonatomic) BOOL streamingVoiceData;
@property (nonatomic, strong) SCAEmotionsAnalyzerSession *emotionsAnalyzerSession;
@property (nonatomic, strong) NSMutableArray *analysisSegments;
@property (nonatomic, strong) VoiceDataStreamer *voiceDataStreamer;
@property (nonatomic, strong) VoiceRecorder *voiceRecorder;

-(IBAction)btnStartStopSession_Pressed:(id)sender;
-(IBAction)btnSendSampleFile_Pressed:(id)sender;

@end
