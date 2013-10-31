//
//  SCAStringAnalysis.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCATemperMeterValues.h"

@interface SCAStringAnalysis : NSObject

@property (nonatomic, strong) NSString *value;

/**
 * Method name: initWithDictionary
 * Description: Initialize with dictionary from server response
 * Parameters:  dictionary - dictionary from server response
 */
-(id)initWithDictionary:(NSDictionary*)dictionary;

/**
 * Method name: isLow
 * Description: Checks is temper value is low
 */
-(BOOL)isLow;

/**
 * Method name: isMed
 * Description: Checks is temper value is medium
 */
-(BOOL)isMed;

/**
 * Method name: isHigh
 * Description: Checks is temper value is high
 */
-(BOOL)isHigh;

@end
