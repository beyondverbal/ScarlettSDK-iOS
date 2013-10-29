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

-(id)initWithDictionary:(NSDictionary*)dictionary;

-(BOOL)isLow;
-(BOOL)isMed;
-(BOOL)isHigh;

@end
