//
//  SCAEmotionsAnalyzerSessionDelegate.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAAnalysisResult.h"

@protocol SCAEmotionsAnalyzerSessionDelegate <NSObject>

-(void)startSessionSucceed;
-(void)startSessionFailed:(NSString*)errorDescription;
-(void)processingDone;
-(void)newAnalysis:(SCAAnalysisResult*)analysisResult;

@end
