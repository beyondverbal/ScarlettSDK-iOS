//
//  SCAStartSessionResponder.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAVoteResponder.h"

@implementation SCAVoteResponder

-(void)loadUrlSucceed:(NSData *)responseData
{
    [self.delegate voteSucceed:responseData];
}

-(void)loadUrlFailed:(NSError *)error
{
    [self.delegate voteFailed:error];
}

@end
