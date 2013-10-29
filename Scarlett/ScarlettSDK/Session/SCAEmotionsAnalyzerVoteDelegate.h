//
//  SCAEmotionsAnalyzerSessionDelegate.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAVoteResult.h"

@protocol SCAEmotionsAnalyzerVoteDelegate <NSObject>

-(void)voteSucceed:(SCAVoteResult*)voteResult;
-(void)voteFailed:(NSString*)errorDescription;

@end
