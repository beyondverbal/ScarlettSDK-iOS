//
//  MainViewController.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/28/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "MainViewController.h"

NSString * const kSampleWavFileName = @"Sample.WAV";
NSTimeInterval const kRequestTimeout = 30.0;
NSTimeInterval const kGetAnalysisTimeInterval = 5.0;
float const kCollectedVoiceDataIntervalMilliseconds = 2000;

@implementation MainViewController

#pragma mark IBAction

-(IBAction)btnStartStopSession_Pressed:(id)sender
{
    if(!self.sessionStarted)
    {
        self.streamingVoiceData = YES;
        
        [self initData];
        
        [self initView];
        
        [self startSession];
    }
    else
    {
        [self stopSession];
    }
}

-(IBAction)btnSendSampleFile_Pressed:(id)sender
{
    if(!self.sessionStarted)
    {
        self.streamingVoiceData = NO;
        
        [self initData];
        
        [self initView];
        
        [self startSession];
    }
}

-(void)initData
{
    self.analysisSegments = [[NSMutableArray alloc] init];
}

-(void)initView
{
    [self.tblAnalysisList reloadData];
}

-(void)sendSampleFile
{
    self.lblStatus.text = @"Sending Sample.wav file";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:kSampleWavFileName ofType:nil];
    
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
    
    [self.emotionsAnalyzerSession analyzeInputStream:inputStream];
}

-(void)startSession
{
    self.btnSendSampleFile.enabled = NO;
    self.btnStartStopSession.enabled = NO;
    
    self.lblStatus.text = @"Starting session...";
    
    SCABaseDataFormat *dataFormat;
    
    if(self.streamingVoiceData)
    {
        dataFormat = [[SCAPcmDataFormat alloc] initWithSampleRate:8000 bitsPerSample:16 channels:1];
    }
    else
    {
        dataFormat = [[SCAWavDataFormat alloc] initWithSampleRate:8000 bitsPerSample:16 channels:1];
    }
    
    SCARecorderInfo *recorderInfo = [[SCARecorderInfo alloc] init];
    
    recorderInfo.ip = @"";
    recorderInfo.coordinates = nil;
    recorderInfo.gender = nil;
    recorderInfo.email = @"some@email.com";
    recorderInfo.phone = @"0505005005";
    recorderInfo.facebook_id = @"1111111";
    recorderInfo.twitter_id = @"2222222";
    recorderInfo.device_info = @"iPhone";
    
    SCARequiredAnalysis *requiredAnalysis = [[SCARequiredAnalysis alloc] initWithRequiredAnalysis:@[SCARequiredAnalysisTemperValue,
                                                                                                    SCARequiredAnalysisTemperMeter,
                                                                                                    SCARequiredAnalysisComposureMeter,
                                                                                                    SCARequiredAnalysisCooperationLevel,
                                                                                                    SCARequiredAnalysisServiceScore,
                                                                                                    SCARequiredAnalysisCompositMood,
                                                                                                    SCARequiredAnalysisMoodGroup,
                                                                                                    SCARequiredAnalysisMoodGroupSummary]];
    
    SCASessionParameters *sessionParameters = [[SCASessionParameters alloc] initWithDataFormat:dataFormat recorderInfo:recorderInfo requiredAnalysisTypes:requiredAnalysis];
        
    self.emotionsAnalyzerSession = [SCAEmotionsAnalyzer initializeSession:sessionParameters apiKey:nil requestTimeout:kRequestTimeout getAnalysisTimeInterval:kGetAnalysisTimeInterval host:kEmotionAnalysisHostBeta sessionDelegate:self];
    
    [self.emotionsAnalyzerSession startSession];
}

-(void)stopSession
{
    self.sessionStarted = NO;
    
    [self stopRecording];

    if(self.streamingVoiceData)
    {
        [self.emotionsAnalyzerSession stopSession];
    }
}

#pragma mark EmotionsAnalyzerSession delegates

-(void)startSessionSucceed
{
    self.sessionStarted = YES;
    
    self.lblStatus.text = @"Session started :)";
    
    if(self.streamingVoiceData)
    {
        self.voiceDataStreamer = [[VoiceDataStreamer alloc] initWithEmotionsAnalyzerSession:self.emotionsAnalyzerSession collectedVoiceDataIntervalMilliseconds:kCollectedVoiceDataIntervalMilliseconds];
        
        [self startRecording];
    }
    else
    {
        self.voiceDataStreamer = nil;
        
        [self sendSampleFile];
    }
}

-(void)startSessionFailed:(NSString*)errorDescription
{
    self.btnSendSampleFile.enabled = YES;
    self.btnStartStopSession.enabled = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error starting session" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)processingDone
{
    self.btnSendSampleFile.enabled = YES;
    self.btnStartStopSession.enabled = YES;
    
    [self stopRecording];
}

-(void)newAnalysis:(SCAAnalysisResult *)analysisResult
{
    NSLog(@"newAnalysis %@", analysisResult);
    
    if(analysisResult.analysisSegments && [analysisResult.analysisSegments count] > 0)
    {
        NSArray *analysisSegments = analysisResult.analysisSegments;
        
        for (SCASegment *segment in analysisSegments)
        {
            [self.analysisSegments addObject:segment];
        }
        
        [self.tblAnalysisList reloadData];
    }
    
    if([analysisResult isSessionStatusDone])
    {
        [self stopSession];
        
        self.lblStatus.text = @"Finished recieving analysis";
        self.btnSendSampleFile.enabled = YES;
        self.btnStartStopSession.enabled = YES;
        self.btnStartStopSession.titleLabel.text = @"Start Stream";
    }
}

#pragma mark - Recording

- (void)startRecording
{
    self.lblStatus.text = @"Starting recording...";
 
    self.voiceRecorder = [[VoiceRecorder alloc] init];
    
    BOOL recordingStarted = [self.voiceRecorder startRecording:self.streamingVoiceData];
    
    if(recordingStarted)
    {
        self.lblStatus.text = @"Recording";
        self.btnSendSampleFile.enabled = YES;
        self.btnStartStopSession.enabled = YES;
        self.btnStartStopSession.titleLabel.text = @"Stop Stream";
    }
    else
    {
        self.lblStatus.text = @"Record Failed";
        self.btnSendSampleFile.enabled = YES;
        self.btnStartStopSession.enabled = YES;
        self.btnStartStopSession.titleLabel.text = @"Start Stream";
    }
}

- (void)stopRecording
{
    [self.voiceRecorder stopRecording];
    
    self.lblStatus.text = @"Recording stopped";
    self.btnSendSampleFile.enabled = YES;
    self.btnStartStopSession.enabled = YES;
    self.btnStartStopSession.titleLabel.text = @"Start Stream";
}


#pragma mark - UITableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.analysisSegments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SCASegment *segment = [self.analysisSegments objectAtIndex:indexPath.row];
    
    cell.textLabel.text = segment.analysis.compositMood.value.primary;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCASegment *segment = [self.analysisSegments objectAtIndex:indexPath.row];
    
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithEmotionsAnalyzerSession:self.emotionsAnalyzerSession segment:segment];
    
    [self presentViewController:detailsViewController animated:YES completion:nil];
}

@end
