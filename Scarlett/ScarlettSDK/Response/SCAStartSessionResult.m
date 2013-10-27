//
//  SCAResult.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAStartSessionResult.h"

@implementation SCAStartSessionResult

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

-(BOOL)isSucceed
{
    return [self.status isEqualToString:kResponseStatusSucceed];
}

@end
