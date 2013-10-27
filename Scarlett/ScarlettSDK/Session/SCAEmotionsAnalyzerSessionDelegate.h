//
//  SCAEmotionsAnalyzerSessionDelegate.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCAEmotionsAnalyzerSessionDelegate <NSObject>
@optional
-(void)startSessionSucceed;
-(void)startSessionFailed:(NSString*)errorDescription;
-(void)upStreamVoiceDataSucceed;
-(void)upStreamVoiceDataFailed:(NSString*)errorDescription;
-(void)getAnalysisSucceed;
-(void)getAnalysisFailed:(NSString*)errorDescription;
-(void)voteSucceed;
-(void)voteFailed;
-(void)newAnalysisRecieved;
@end
