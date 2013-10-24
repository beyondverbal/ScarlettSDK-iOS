//
//  SCARecorderInfo.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAGeoLocation.h"


@interface SCARecorderInfo : NSObject

@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) SCAGeoLocation *coordinates;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *facebook_id;
@property (nonatomic, strong) NSString *twitter_id;
@property (nonatomic, strong) NSString *device_info;
@property (nonatomic, strong) NSString *device_id;

-(NSMutableDictionary*)toDictionary;

@end
