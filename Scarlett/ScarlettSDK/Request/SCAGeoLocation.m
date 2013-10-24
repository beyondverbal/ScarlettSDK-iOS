//
//  SCAGeoLocation.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAGeoLocation.h"

@implementation SCAGeoLocation

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSNumber numberWithDouble:self.x] forKey:@"x"];
    [dictionary setObject:[NSNumber numberWithDouble:self.y] forKey:@"y"];
    
    return dictionary;
}

@end
