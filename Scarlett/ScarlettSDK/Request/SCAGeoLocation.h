//
//  SCAGeoLocation
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAGeoLocation : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;

/**
 * Method name: toDictionary
 * Description: Convert parameters to dictionary
 */
-(NSMutableDictionary*)toDictionary;

@end
