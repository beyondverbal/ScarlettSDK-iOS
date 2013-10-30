//
//  SCAStartSessionResponder.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAUpStreamVoiceResponder.h"

@implementation SCAUpStreamVoiceResponder

-(void)streamSucceed:(NSData *)responseData
{
    [self.delegate upStreamVoiceSucceed:responseData];
}

-(void)streamFailed:(NSString *)errorDescription
{
    [self.delegate upStreamVoiceFailed:errorDescription];
}

-(void)streamStopped
{
    [self.delegate upStreamVoiceStopped];
}

@end
