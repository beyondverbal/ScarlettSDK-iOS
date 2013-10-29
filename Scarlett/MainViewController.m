//
//  MainViewController.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/28/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "MainViewController.h"

NSString* const kApiKey = @"66c7581c48b54589b046e489fafab19e";
NSString* const kUpStreamVoiceDataNotification = @"UpStreamVoiceDataNotification";
NSString* const kUpStreamVoiceDataKey = @"UpStreamVoiceDataKey";
NSTimeInterval const kRequestTimeout = 120.0;
NSTimeInterval const kGetAnalysisTimeInterval = 5.0;
float const kCollectedVoiceDataMilliseconds = 2000;

void AudioInputCallback(void * inUserData,
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp * inStartTime,
                        UInt32 inNumberPacketDescriptions,
                        const AudioStreamPacketDescription * inPacketDescs);

void AudioOutputCallback(void * inUserData,
                         AudioQueueRef outAQ,
                         AudioQueueBufferRef outBuffer);

@implementation MainViewController

-(id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(upStreamVoiceDataNotification:)
                                                     name:kUpStreamVoiceDataNotification
                                                   object:nil];
    }
    return self;
}

- (void)upStreamVoiceDataNotification:(NSNotification*)notification
{
    NSData *voiceData = [notification.userInfo objectForKey:kUpStreamVoiceDataKey];
    
    NSLog(@"............collectedVoiceData %d", [self.collectedVoiceData length]);
    NSLog(@"............voiceData %d", [voiceData length]);
    
    [self.collectedVoiceData appendData:voiceData];
    
    NSLog(@"............collectedVoiceData %d", [self.collectedVoiceData length]);
    
    if(collectedVoiceDataMilliseconds > 0)
    {
        float currentMillisecond = [SCAMillisecondsUtils getMilliseconds];
        
        if(currentMillisecond - collectedVoiceDataMilliseconds >= kCollectedVoiceDataMilliseconds)
        {
            collectedVoiceDataMilliseconds = [SCAMillisecondsUtils getMilliseconds];
            
            NSData *newVoiceData = [NSData dataWithData:self.collectedVoiceData];
            
            [self.emotionsAnalyzerSession upStreamVoiceData:newVoiceData];
            
            self.collectedVoiceData = [[NSMutableData alloc] init];
        }
    }
    else
    {
        collectedVoiceDataMilliseconds = [SCAMillisecondsUtils getMilliseconds];
    }
}

-(IBAction)btnStartStopSession_Pressed:(id)sender
{
    if(!self.sessionStarted)
    {
        [self initData];
        
        [self initView];
        
        [self startSession];
    }
    else
    {
        [self stopSession];
    }
}

-(void)initData
{
    self.analysisSegments = [[NSMutableArray alloc] init];
    self.collectedVoiceData = [[NSMutableData alloc] init];
}

-(void)initView
{
    [self.tblAnalysisList reloadData];
}

-(void)startSession
{
    self.btnStartStopSession.enabled = NO;
    
    self.lblStatus.text = @"Starting session...";
    
    SCABaseDataFormat *dataFormat = [[SCAPcmDataFormat alloc] initWithSampleRate:8000 bitsPerSample:16 channels:1];
    
    SCARecorderInfo *recorderInfo = [[SCARecorderInfo alloc] init];
    
    recorderInfo.ip = @"";
    recorderInfo.coordinates = nil;
    recorderInfo.gender = nil;
    recorderInfo.email = @"some@email.com";
    recorderInfo.phone = @"0505005005";
    recorderInfo.facebook_id = @"1111111";
    recorderInfo.twitter_id = @"2222222";
    recorderInfo.device_info = @"iPhone";
    recorderInfo.device_id = @"3333333"; //TODO: init with OpenID
    
    SCARequiredAnalysis *requiredAnalysis = [[SCARequiredAnalysis alloc] initWithRequiredAnalysis:@[SCARequiredAnalysisTemperValue,
                                                                                                    SCARequiredAnalysisTemperMeter,
                                                                                                    SCARequiredAnalysisComposureMeter,
                                                                                                    SCARequiredAnalysisCooperationLevel,
                                                                                                    SCARequiredAnalysisServiceScore,
                                                                                                    SCARequiredAnalysisCompositMood,
                                                                                                    SCARequiredAnalysisMoodGroup,
                                                                                                    SCARequiredAnalysisMoodGroupSummary]];
    
    SCASessionParameters *sessionParameters = [[SCASessionParameters alloc] initWithDataFormat:dataFormat recorderInfo:recorderInfo requiredAnalysisTypes:requiredAnalysis];
    
    self.emotionsAnalyzer = [[SCAEmotionsAnalyzer alloc] initWithApiKey:kApiKey requestTimeout:kRequestTimeout getAnalysisTimeInterval:kGetAnalysisTimeInterval host:kEmotionAnalysisHostBeta delegate:self];
    
    self.emotionsAnalyzerSession = [self.emotionsAnalyzer initializeSession:sessionParameters];
    
    [self.emotionsAnalyzerSession startSession];
}

-(void)stopSession
{
    self.sessionStarted = NO;
    
    [self stopRecording];
    
    [self.emotionsAnalyzerSession stopSession];
}

//-(IBAction)sendFileClicked:(id)sender
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"SUPER_test1_LPCM_Mono_VBR_8SS_24000Hz.WAV" ofType:nil];
//    
//    NSData *voiceData = [NSData dataWithContentsOfFile:path];
//    
//    [self.emotionsAnalyzerSession upStreamVoiceData:voiceData];
//}
//
//-(IBAction)sendRecordedFileClicked:(id)sender
//{
//    NSString *path = [self getAudioFilePath];
//    
//    NSData *newVoiceData = [NSData dataWithContentsOfFile:path];
//    
//    NSLog(@":::::::::::::::: sendRecordedFileClicked %d", [newVoiceData length]);
//    
//    [self.emotionsAnalyzerSession upStreamVoiceData:newVoiceData];
//}
//
//-(IBAction)sendCollectedVoiceDataClicked:(id)sender
//{
//    NSData *newVoiceData = [NSData dataWithData:self.collectedVoiceData];
//    
//    NSLog(@",,,,,,,,,,,,,,,, sendCollectedVoiceDataClicked %d", [newVoiceData length]);
//    
//    [self.emotionsAnalyzerSession upStreamVoiceData:newVoiceData];
//}

-(void)startSessionSucceed
{
    self.sessionStarted = YES;
    
    self.lblStatus.text = @"Session started :)";
    
    [self startRecording];
}

-(void)startSessionFailed:(NSString*)errorDescription
{
    self.btnStartStopSession.enabled = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error starting session" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)upStreamVoiceDataSucceed
{
    //TODO:
    
    [self stopRecording];
}

-(void)upStreamVoiceDataFailed:(NSString *)errorDescription
{
    //TODO:
    
    [self stopRecording];
}

-(void)getAnalysisSucceed:(SCAAnalysisResult *)analysisResult
{
    NSLog(@"getAnalysisSucceed %@", analysisResult);
    
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
    }
}

-(void)getAnalysisFailed:(NSString *)errorDescription
{
    NSLog(@"getAnalysisFailed %@", errorDescription);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting analysis" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - audio recording

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
        printf("Not recording, returning\n");
    }
    
    printf("Writing buffer %lld\n", recordState->currentPacket);
    OSStatus status = AudioFileWritePackets(recordState->audioFile,
                                            false,
                                            inBuffer->mAudioDataByteSize,
                                            inPacketDescs,
                                            recordState->currentPacket,
                                            &inNumberPacketDescriptions,
                                            inBuffer->mAudioData);
    
    // send notification with recorded data
    NSData *data = [NSData dataWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:data forKey:kUpStreamVoiceDataKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpStreamVoiceDataNotification object:nil userInfo:userInfo];
    
    if (status == 0)
    {
        recordState->currentPacket += inNumberPacketDescriptions;
    }
    
    AudioQueueEnqueueBuffer(recordState->queue, inBuffer, 0, NULL);
}

// Fills an empty buffer with data and sends it to the speaker
void AudioOutputCallback(void * inUserData,
                         AudioQueueRef outAQ,
                         AudioQueueBufferRef outBuffer)
{
	PlayState* playState = (PlayState*)inUserData;
    if(!playState->playing)
    {
        printf("Not playing, returning\n");
        return;
    }
    
	printf("Queuing buffer %lld for playback\n", playState->currentPacket);
    
    AudioStreamPacketDescription* packetDescs = NULL;
    
    UInt32 bytesRead;
    UInt32 numPackets = 8000;
    OSStatus status;
    status = AudioFileReadPackets(playState->audioFile,
                                  false,
                                  &bytesRead,
                                  packetDescs,
                                  playState->currentPacket,
                                  &numPackets,
                                  outBuffer->mAudioData);
    
    if (numPackets)
    {
        outBuffer->mAudioDataByteSize = bytesRead;
        status = AudioQueueEnqueueBuffer(playState->queue,
                                         outBuffer,
                                         0,
                                         packetDescs);
        
        playState->currentPacket += numPackets;
    }
    else
    {
        if (playState->playing)
        {
            AudioQueueStop(playState->queue, false);
            AudioFileClose(playState->audioFile);
            playState->playing = false;
        }
        
        AudioQueueFreeBuffer(playState->queue, outBuffer);
    }
}

- (void)setupAudioFormat:(AudioStreamBasicDescription*)format
{
	format->mSampleRate = 8000.0;
	format->mFormatID = kAudioFormatLinearPCM;
    //format->mFormatID = kAudioFormatULaw;
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

- (void)startRecording
{
    self.collectedVoiceData = [[NSMutableData alloc] init];
    
    // Get audio file page
    char path[256];
    [self getAudioFileName:path maxLenth:sizeof path];
    fileURL = CFURLCreateFromFileSystemRepresentation(NULL, (UInt8*)path, strlen(path), false);
    
    // Init state variables
    recordState.recording = false;
    
    self.lblStatus.text = @"Starting recording...";
    
    [self setupAudioFormat:&recordState.dataFormat];
    
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
        
        status = AudioFileCreateWithURL(fileURL,
                                        kAudioFileAIFFType,
                                        &recordState.dataFormat,
                                        kAudioFileFlags_EraseFile,
                                        &recordState.audioFile);
        
        //        status = AudioFileCreateWithURL(fileURL,
        //                                        kAudioFileWAVEType,
        //                                        &recordState.dataFormat,
        //                                        kAudioFileFlags_EraseFile,
        //                                        &recordState.audioFile);
        
        if (status == 0)
        {
            recordState.recording = true;
            status = AudioQueueStart(recordState.queue, NULL);
            if (status == 0)
            {
                self.lblStatus.text = @"Recording";
                self.btnStartStopSession.enabled = YES;
                self.btnStartStopSession.titleLabel.text = @"Stop";
            }
        }
    }
    
    if (status != 0)
    {
        [self stopRecording];
        self.lblStatus.text = @"Record Failed";
        self.btnStartStopSession.enabled = YES;
        self.btnStartStopSession.titleLabel.text = @"Start";
    }
}

- (void)stopRecording
{
    recordState.recording = false;
    
    AudioQueueStop(recordState.queue, true);
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueFreeBuffer(recordState.queue, recordState.buffers[i]);
    }
    
    AudioQueueDispose(recordState.queue, true);
    AudioFileClose(recordState.audioFile);
    self.lblStatus.text = @"Recording stopped";
    self.btnStartStopSession.enabled = YES;
    self.btnStartStopSession.titleLabel.text = @"Start";
}


- (void)startPlayback
{
    playState.currentPacket = 0;
    
    [self setupAudioFormat:&playState.dataFormat];
    
    OSStatus status;
    status = AudioFileOpenURL(fileURL, kAudioFileReadPermission, kAudioFileAIFFType, &playState.audioFile);
    //status = AudioFileOpenURL(fileURL, kAudioFileReadPermission, kAudioFileWAVEType, &playState.audioFile);
    if (status == 0)
    {
        status = AudioQueueNewOutput(&playState.dataFormat,
                                     AudioOutputCallback,
                                     &playState,
                                     CFRunLoopGetCurrent(),
                                     kCFRunLoopCommonModes,
                                     0,
                                     &playState.queue);
        
        if (status == 0)
        {
            // Allocate and prime playback buffers
            playState.playing = true;
            for (int i = 0; i < NUM_BUFFERS && playState.playing; i++)
            {
                AudioQueueAllocateBuffer(playState.queue, 16000, &playState.buffers[i]);
                AudioOutputCallback(&playState, playState.queue, playState.buffers[i]);
            }
            
            status = AudioQueueStart(playState.queue, NULL);
            if (status == 0)
            {
                self.lblStatus.text = @"Playing";
            }
        }
    }
    
    if (status != 0)
    {
        [self stopPlayback];
        self.lblStatus.text = @"Play failed";
    }
}

- (void)stopPlayback
{
    playState.playing = false;
    
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueFreeBuffer(playState.queue, playState.buffers[i]);
    }
    
    AudioQueueDispose(playState.queue, true);
    AudioFileClose(playState.audioFile);
}

- (BOOL)getAudioFileName:(char*)buffer maxLenth:(int)maxBufferLength
{
    NSString *file = [self getAudioFilePath];
    
    return [file getCString:buffer maxLength:maxBufferLength encoding:NSUTF8StringEncoding];
}

-(NSString*)getAudioFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString* docDir = [paths objectAtIndex:0];
    
    NSString* file = [docDir stringByAppendingString:@"/recording.wav"];
    
    return file;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO:
}

@end
