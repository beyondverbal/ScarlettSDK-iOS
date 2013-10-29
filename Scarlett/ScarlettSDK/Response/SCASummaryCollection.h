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

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
