//
//  SCASummaryCollection.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/29/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCACompositStringAnalysis.h"

@interface SCASummaryCollection : NSObject

@property (nonatomic, strong) SCACompositStringAnalysis *moodGroupSummary;

/**
 * Method name: initWithDictionary
 * Description: Initialize with dictionary from server response
 * Parameters:  dictionary - dictionary from server response
 */
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
