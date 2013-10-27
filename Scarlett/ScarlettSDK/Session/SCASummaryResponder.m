//
//  SCAStartSessionResponder.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCASummaryResponder.h"

@implementation SCASummaryResponder

-(void)loadUrlSucceed:(NSData *)responseData
{
    [self.delegate getSummarySucceed:responseData];
}

-(void)loadUrlFailed:(NSError *)error
{
    [self.delegate getSummaryFailed:error];
}

@end
