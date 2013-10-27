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
        
        NSLog(@"SCAAnalysisResult %@", jsonObject);
        
        NSDictionary *dictionary = (NSDictionary*)jsonObject;
        
        
//        self.status = [dictionary objectForKey:@"status"];
//        
//        if([self.status isEqualToString:kResponseStatusSucceed])
//        {
//            NSDictionary *followupActionsDictionary = [dictionary objectForKey:@"followupActions"];
//            
//            self.followupActions = [[SCAFollowupActions alloc] initWithDictionary:followupActionsDictionary];
//        }
//        else if ([self.status isEqualToString:kResponseStatusFailure])
//        {
//            self.reason = [dictionary objectForKey:@"reason"];
//        }
//        else
//        {
//            @throw([NSException exceptionWithName:@"Unknown status" reason:@"Unknow status received from server: " userInfo:nil]);
//        }
    }
    return self;
}

@end
