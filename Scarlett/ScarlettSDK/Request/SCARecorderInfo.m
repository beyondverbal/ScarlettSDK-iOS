//
//  SCARecorderInfo.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCARecorderInfo.h"

@implementation SCARecorderInfo

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if(self.ip)
    {
        [dictionary setObject:self.ip forKey:@"ip"];
    }
    
    if(self.coordinates)
    {
        [dictionary setObject:[self.coordinates toDictionary] forKey:@"coordinates"];
    }
    
    if(self.gender)
    {
        [dictionary setObject:self.gender forKey:@"gender"];
    }
    
    if(self.email)
    {
        [dictionary setObject:self.email forKey:@"email"];
    }
    
    if(self.phone)
    {
        [dictionary setObject:self.phone forKey:@"phone"];
    }
    
    if(self.facebook_id)
    {
        [dictionary setObject:self.facebook_id forKey:@"facebook_id"];
    }
    
    if(self.twitter_id)
    {
        [dictionary setObject:self.twitter_id forKey:@"twitter_id"];
    }
    
    if(self.device_info)
    {
        [dictionary setObject:self.device_info forKey:@"device_info"];
    }
    
    [dictionary setObject:[self getDeviceId] forKey:@"device_id"];
    
    return dictionary;
}

-(NSString*)getDeviceId
{
    if(!_deviceId)
    {
        //TODO: get open id
    }
    
    return _deviceId;
}

@end
