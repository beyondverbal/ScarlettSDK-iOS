//
//  SCAEmotionsAnalyzerSessionDelegate.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCASummaryResult.h"

@protocol SCAEmotionsAnalyzerSummaryDelegate <NSObject>

-(void)getSummarySucceed:(SCASummaryResult*)summaryResult;
-(void)getSummaryFailed:(NSString*)errorDescription;

@end
