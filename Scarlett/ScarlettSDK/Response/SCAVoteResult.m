//
//  SCAVoteResult.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/27/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAVoteResult.h"

@implementation SCAVoteResult

-(id)initWithResponseData:(NSData*)responseData
{
    if(self = [super init])
    {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *dictionary = (NSDictionary*)jsonObject;
        
        self.status = [dictionary objectForKey:@"status"];
        
        if([self.status isEqualToString:kResponseStatusSucceed])
        {
            self.result = [dictionary objectForKey:@"result"];
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

@end
