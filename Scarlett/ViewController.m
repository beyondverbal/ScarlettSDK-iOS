//
//  ViewController.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "ViewController.h"

NSString* const kApiKey = @"66c7581c48b54589b046e489fafab19e";
NSString* const kUpStreamVoiceDataNotification = @"UpStreamVoiceDataNotification";
NSString* const kUpStreamVoiceDataKey = @"UpStreamVoiceDataKey";
const float kCollectedVoiceDataMilliseconds = 2000;

// Declare C callback functions
void AudioInputCallback(void * inUserData,  // Custom audio metadata
                        AudioQueueRef inAQ,
                        AudioQueueBufferRef inBuffer,
                        const AudioTimeStamp * inStartTime,
                        UInt32 inNumberPacketDescriptions,
                        const AudioStreamPacketDescription * inPacketDescs);

void AudioOutputCallback(void * inUserData,
                         AudioQueueRef outAQ,
                         AudioQueueBufferRef outBuffer);

@implementation ViewController

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

-(void)upStreamVoiceDataSucceed
{
    //TODO:
}

-(void)upStreamVoiceDataFailed:(NSString *)errorDescription
{
    //TODO:
}

-(IBAction)startSessionClicked:(id)sender
{
    [self startSession];
}

-(IBAction)stopSessionClicked:(id)sender
{
    [self.emotionsAnalyzerSession stopSession];
}

-(IBAction)sendFileClicked:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SUPER_test1_LPCM_Mono_VBR_8SS_24000Hz.WAV" ofType:nil];
    
    NSData *voiceData = [NSData dataWithContentsOfFile:path];
    
    [self.emotionsAnalyzerSession upStreamVoiceData:voiceData];
}

-(IBAction)startRecordingClicked:(id)sender
{
    [self startRecording];
}

-(IBAction)stopRecordingClicked:(id)sender
{
    [self stopRecording];
}

-(IBAction)startPlayingClicked:(id)sender
{
    [self startPlayback];
}

-(IBAction)stopPlayingClicked:(id)sender
{
    [self stopPlayback];
}

-(IBAction)sendRecordedFileClicked:(id)sender
{
    NSString *path = [self getAudioFilePath];
    
    NSData *newVoiceData = [NSData dataWithContentsOfFile:path];
    
    NSLog(@":::::::::::::::: sendRecordedFileClicked %d", [newVoiceData length]);
    
    [self.emotionsAnalyzerSession upStreamVoiceData:newVoiceData];
}

-(IBAction)sendCollectedVoiceDataClicked:(id)sender
{
    NSData *newVoiceData = [NSData dataWithData:self.collectedVoiceData];
    
    NSLog(@",,,,,,,,,,,,,,,, sendCollectedVoiceDataClicked %d", [newVoiceData length]);
    
    [self.emotionsAnalyzerSession upStreamVoiceData:newVoiceData];
}

-(void)getAnalysisSucceed:(SCAAnalysisResult *)analysisResult
{
    //TODO: display results
}

-(void)getAnalysisFailed:(NSString *)errorDescription
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting analysis" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(IBAction)compareFileWithCollectedDataClicked:(id)sender
{
    NSLog(@"????????????  compareFileWithCollectedDataClicked ???????????");
    
    NSString *path = [self getAudioFilePath];
    
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    NSData *voiceData = [NSData dataWithData:self.collectedVoiceData];
    
    NSRange range = NSMakeRange(0, 4096);
    NSRange range2 = NSMakeRange(4096, 4096);
    
    NSLog(@"__________ fileData ___________");
    NSLog(@"%@", [fileData subdataWithRange:range]);
    NSLog(@"__________ fileData 2 ___________");
    NSLog(@"%@", [fileData subdataWithRange:range2]);
    NSLog(@"__________ voiceData ___________");
    NSLog(@"%@", [voiceData subdataWithRange:range]);
    
    NSLog(@"____________ fileDataStartString ____________");
    NSString *fileDataStartString = [[NSString alloc] initWithData:[fileData subdataWithRange:range] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", fileDataStartString);
    
    NSLog(@"__________ headerData ___________");

    long totalAudioLen = [self.collectedVoiceData length];
    long totalDataLen = totalAudioLen + 44;
    long longSampleRate = 8000.0;
    int channels = 1;
    long byteRate = 16 * 8000.0 * channels/8;
    
    
    Byte *header = (Byte*)malloc(44);
    header[0] = 'R';  // RIFF/WAVE header
    header[1] = 'I';
    header[2] = 'F';
    header[3] = 'F';
    header[4] = (Byte) (totalDataLen & 0xff);
    header[5] = (Byte) ((totalDataLen >> 8) & 0xff);
    header[6] = (Byte) ((totalDataLen >> 16) & 0xff);
    header[7] = (Byte) ((totalDataLen >> 24) & 0xff);
    header[8] = 'W';
    header[9] = 'A';
    header[10] = 'V';
    header[11] = 'E';
    header[12] = 'f';  // 'fmt ' chunk
    header[13] = 'm';
    header[14] = 't';
    header[15] = ' ';
    header[16] = 16;  // 4 bytes: size of 'fmt ' chunk
    header[17] = 0;
    header[18] = 0;
    header[19] = 0;
    header[20] = 1;  // format = 1
    header[21] = 0;
    header[22] = (Byte) channels;
    header[23] = 0;
    header[24] = (Byte) (longSampleRate & 0xff);
    header[25] = (Byte) ((longSampleRate >> 8) & 0xff);
    header[26] = (Byte) ((longSampleRate >> 16) & 0xff);
    header[27] = (Byte) ((longSampleRate >> 24) & 0xff);
    header[28] = (Byte) (byteRate & 0xff);
    header[29] = (Byte) ((byteRate >> 8) & 0xff);
    header[30] = (Byte) ((byteRate >> 16) & 0xff);
    header[31] = (Byte) ((byteRate >> 24) & 0xff);
    header[32] = (Byte) (2 * 8 / 8);  // block align
    header[33] = 0;
    header[34] = 16;  // bits per sample
    header[35] = 0;
    header[36] = 'd';
    header[37] = 'a';
    header[38] = 't';
    header[39] = 'a';
    header[40] = (Byte) (totalAudioLen & 0xff);
    header[41] = (Byte) ((totalAudioLen >> 8) & 0xff);
    header[42] = (Byte) ((totalAudioLen >> 16) & 0xff);
    header[43] = (Byte) ((totalAudioLen >> 24) & 0xff);
    
    
    NSData *headerData = [NSData dataWithBytes:header length:44];
    NSLog(@"%@", headerData);
    
    NSLog(@"????????????  compareFileWithCollectedDataClicked ???????????");
}

-(void)startSession
{
    self.labelStatus.text = @"Starting session...";
    
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
    
    SCARequiredAnalysis *requiredAnalysis = [[SCARequiredAnalysis alloc] init];
    requiredAnalysis.requiredAnalisys = @[SCARequiredAnalysisComposureMeter, SCARequiredAnalysisTemperValue];
    
    SCASessionParameters *sessionParameters = [[SCASessionParameters alloc] initWithDataFormat:dataFormat recorderInfo:recorderInfo requiredAnalysisTypes:requiredAnalysis];
    
    self.emotionsAnalyzerSession = [[SCAEmotionsAnalyzerSession alloc] initWithSessionParameters:sessionParameters apiKey:kApiKey requestTimeout:130.0 getAnalysisTimeInterval:5.0 host:kEmotionAnalysisHostBeta delegate:self];
    [self.emotionsAnalyzerSession startSession];
}

-(void)startSessionSucceed
{
    self.labelStatus.text = @"Session started :)";
}

-(void)startSessionFailed:(NSString*)errorDescription
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error starting session" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    
    // if (inNumberPacketDescriptions == 0 && recordState->dataFormat.mBytesPerPacket != 0)
    // {
    //     inNumberPacketDescriptions = inBuffer->mAudioDataByteSize / recordState->dataFormat.mBytesPerPacket;
    // }
    
    printf("Writing buffer %lld\n", recordState->currentPacket);
    OSStatus status = AudioFileWritePackets(recordState->audioFile,
                                            false,
                                            inBuffer->mAudioDataByteSize,
                                            inPacketDescs,
                                            recordState->currentPacket,
                                            &inNumberPacketDescriptions,
                                            inBuffer->mAudioData);
    
    //TODO: Daniel test
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
    
    self.labelStatus.text = @"Starting recording...";
    
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
                self.labelStatus.text = @"Recording";
            }
        }
//        else
//        {
//            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain
//                                                 code:status
//                                             userInfo:nil];
//            NSLog(@"Error: %@", [error description]);
//        }
    }
    
    if (status != 0)
    {
        [self stopRecording];
        self.labelStatus.text = @"Record Failed";
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
    self.labelStatus.text = @"Idle";
    
    //TODO: [self.emotionsAnalyzerSession upStreamVoiceDataStop];
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
                self.labelStatus.text = @"Playing";
            }
        }
    }
    
    if (status != 0)
    {
        [self stopPlayback];
        self.labelStatus.text = @"Play failed";
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

@end
