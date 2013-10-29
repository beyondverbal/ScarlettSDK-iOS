//
//  SCASummaryResult.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCASummaryResult.h"

@implementation SCASummaryResult

-(id)initWithResponseData:(NSData*)responseData
{
    if(self = [super init])
    {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"SCAAnalysisResult %@", jsonObject);
        
        NSDictionary *dictionary = (NSDictionary*)jsonObject;
        
        self.status = [dictionary objectForKey:@"status"];
        
        if([self.status isEqualToString:kResponseStatusSucceed])
        {
            NSDictionary *followupActionsDictionary = [dictionary objectForKey:@"followupActions"];
            
            self.followupActions = [[SCAFollowupActions alloc] initWithDictionary:followupActionsDictionary];
            
            NSDictionary *resultDictionary = [dictionary objectForKey:@"result"];
            
            self.durationProcessed = [[resultDictionary objectForKey:@"duration"] unsignedLongValue];
            
            self.sessionStatus = [resultDictionary objectForKey:@"sessionStatus"];
            
            NSDictionary *analysisItemsDictionary = [resultDictionary objectForKey:@"analysisItems"];
            
            self.summaryCollection = [[SCASummaryCollection alloc] initWithDictionary:analysisItemsDictionary];
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
