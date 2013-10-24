//
//  SCAStartSessionResponder.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAAnalysisResponder.h"

@implementation SCAAnalysisResponder

-(void)loadUrlSucceed:(NSData *)responseData
{
    [self.delegate analysisSucceed:responseData];
}

-(void)loadUrlFailed:(NSError *)error
{
    [self.delegate analysisFailed:error];
}

@end
