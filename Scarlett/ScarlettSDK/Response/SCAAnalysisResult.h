//
//  SCAAnalysisResult.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAFollowupActions.h"
#import "SCAResponseStatuses.h"
#import "SCASegment.h"

@interface SCAAnalysisResult : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) SCAFollowupActions *followupActions;
@property (nonatomic) unsigned long durationProcessed;
@property (nonatomic, strong) NSMutableArray *analysisSegments;

-(id)initWithResponseData:(NSData*)responseData;

@end
