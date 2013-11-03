Scarlett SDK
============

Overview:
---------

Scarlett SDK - objective-c library that allows you to stream voice data or WAVE file from iPhone/iPad to Beyond Verbal's server and get analysis of the speaker person mood.

Importing Scarlett SDK into new Project:
----------------------------------------
1. Copy Scarlett SDK folder into new project.
2. Go to build option and mark OpenUDID.m as -fno-obj-arc

Available audio streaming options:
----------------------------------

1. Continuously stream voice data (e.g. NSData) to server. In this case there is need to call stop session when finished streaming or stop streaming data and the stream will stop.
2. Stream voice data from WAVE file via NSInputStream. In this case no need to stop stream, it will stop when the file is finished to upload and processingDone will be called.

Getting Started:
----------------

1. Register on Beyond Verbal's site and get API key.
2. Open Scarlett-Info.plist and insert API key in ScarlettApiKey section.
3. Choose what audio format you want to stream:

  Streaming PCM voice data:

      SCABaseDataFormat *dataFormat = [[SCAPcmDataFormat alloc] initWithSampleRate:8000 bitsPerSample:16 channels:1];

  or, streaming a WAVE file:

      SCABaseDataFormat *dataFormat = [[SCAWavDataFormat alloc] initWithSampleRate:8000 bitsPerSample:16 channels:1];

4. Initialize information about recorder:

          SCARecorderInfo *recorderInfo = [[SCARecorderInfo alloc] init];
          recorderInfo.ip = @"";
          recorderInfo.coordinates = nil;
          recorderInfo.gender = nil;
          recorderInfo.email = @"some@email.com";
          recorderInfo.phone = @"0505005005";
          recorderInfo.facebook_id = @"1111111";
          recorderInfo.twitter_id = @"2222222";
          recorderInfo.device_info = @"iPhone";
	 
5. Initialize required analysis types:

        SCARequiredAnalysis *requiredAnalysis = [[SCARequiredAnalysis alloc] initWithRequiredAnalysis:@[SCARequiredAnalysisTemperValue, SCARequiredAnalysisTemperMeter, SCARequiredAnalysisComposureMeter, SCARequiredAnalysisCooperationLevel, SCARequiredAnalysisServiceScore, SCARequiredAnalysisCompositMood, SCARequiredAnalysisMoodGroup, SCARequiredAnalysisMoodGroupSummary]];

6. Initialize session parameters:
	
        SCASessionParameters *sessionParameters = [[SCASessionParameters alloc] initWithDataFormat:dataFormat recorderInfo:recorderInfo requiredAnalysisTypes:requiredAnalysis];
        
7. Initialize analyzer session:

        SCAEmotionsAnalyzerSession *emotionAnalyzerSession = [SCAEmotionsAnalyzer initializeSession:sessionParameterss apiKey:nil plistFileName:@"Scarlett-Info.plist" requestTimeout:kRequestTimeout getAnalysisTimeInterval:kGetAnalysisTimeInterval host:kEmotionAnalysisHostBeta isDebug:YES sessionDelegate:self];
  
8. Starting analysis session:
    
        [emotionAnalyzerSession startSession];

9. To know if session start succeed or failed - implement the following protocol:

        (void)startSessionSucceed
        {
        	// start recording and sending recorded voice data or send WAVE file
        }
        
        (void)startSessionFailed:(NSString*)errorDescription
        {
        	// display error
        }

10. When starting session succeed - start recording audio and send recording data to analysis server by calling:

        [emotionAnalyzerSession analyzeVoiceData:newVoiceData];

  Alternatively, initialize NSInputStream to stream WAVE file:

        NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
        
        [emotionAnalyzerSession analyzeInputStream:inputStream];
	
  Implement the following protocol to know when stream is done:

        (void)processingDone
        {
        		// finished upload file or stream closed - stop recording and sending voice data
        }

11. Finally, you'll need to call stop session when finished streaming:

        [emotionAnalyzerSession stopSession];

12. When session started and some audio data streamed to server - analysis response will start to received (with analysis time interval):

  To get analysis segments - implement the following protocol:

        (void)newAnalysis:(SCAAnalysisResult*)analysisResult
        {
        			NSArray *analysisSegments = analysisResult.analysisSegments;
        
        			for (SCASegment *segment in analysisSegments)
        			{
            			// populate list with analysis segments
        			}
        }

Analysis Summary
----------------

   At any time after receiving at least one analysis response it's possible to get summary analysis:

        [emotionAnalyzerSession getSummary:self];

   To get summary results - implement the following protocols:

        (void)getSummarySucceed:(SCASummaryResult*)summaryResult
        {
        	SCASummaryCollection *summaryCollection = summaryResult.summaryCollection;
        }
        
        (void)getSummaryFailed:(NSString*)errorDescription
        {
        	// display error
        }

Analysis Voting
---------------

At any time after receiving at least one analysis response it's possible to call vote for analysis segment or general vote:

General vote:

      [emotionAnalyzerSession vote:self voteScore:voteScore];

Vote with text:

      [emotionAnalyzerSession vote:self voteScore:voteScore verbalVote:verbalVote];

Vote with text for specific analysis segment:

      [emotionAnalyzerSession vote:self voteScore:voteScore verbalVote:verbalVote segment:analysisSegment];
	
To check if vote succeed of failed - implement the following protocols:

      (void)voteSucceed:(SCAVoteResult*)voteResult
      {
      	NSString *result = voteResult.result;
      }
      
      (void)voteFailed:(NSString*)errorDescription
      {
      	// display error
      }			
			

