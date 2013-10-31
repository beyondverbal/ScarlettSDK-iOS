//
//  SCAAnalysisResult.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAAnalysisResult.h"

@implementation SCAAnalysisResult

-(id)initWithResponseData:(NSData*)responseData
{
    if(self = [super init])
    {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *dictionary = (NSDictionary*)jsonObject;
        
        self.status = [dictionary objectForKey:@"status"];
        
        if([self.status isEqualToString:kResponseStatusSucceed])
        {
            NSDictionary *followupActionsDictionary = [dictionary objectForKey:@"followupActions"];
            
            self.followupActions = [[SCAFollowupActions alloc] initWithDictionary:followupActionsDictionary];
            
            NSDictionary *resultDictionary = [dictionary objectForKey:@"result"];
            
            self.durationProcessed = [[resultDictionary objectForKey:@"duration"] unsignedLongValue];
            
            self.sessionStatus = [resultDictionary objectForKey:@"sessionStatus"];
            
            self.analysisSegments = [[NSMutableArray alloc] init];
            
            NSArray *analysisSegmentsArray = [resultDictionary objectForKey:@"analysisSegments"];
            
            for (NSDictionary *analysisSegmentDictionary in analysisSegmentsArray)
            {
                SCASegment *segment = [[SCASegment alloc] initWithDictionary:analysisSegmentDictionary];
                
                [self.analysisSegments addObject:segment];
            }
        }
        else if ([self.status isEqualToString:kResponseStatusFailure])
        {
            self.reason = [dictionary objectForKey:@"reason"];
        }
        else
        {
            @throw([NSException exceptionWithName:@"Unknown status" reason:@"Unknow status received from server: " userInfo:nil]);
        }
    }
    return self;
}

-(BOOL)isSessionStatusDone
{
    return [self.sessionStatus isEqualToString:kSessionStatusDone];
}

@end
