//
//  SCAStartSessionResponder.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAStartSessionResponder.h"

@implementation SCAStartSessionResponder

-(void)loadUrlSucceed:(NSData *)responseData
{
    [self.delegate startSessionSucceed:responseData];
}

-(void)loadUrlFailed:(NSError *)error
{
    [self.delegate startSessionFailed:error];
}

@end
