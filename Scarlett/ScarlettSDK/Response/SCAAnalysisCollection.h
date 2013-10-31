//
//  SCAAnalysisCollection.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAFloatAnalysis.h"
#import "SCAStringAnalysis.h"
#import "SCACompositStringAnalysis.h"

@interface SCAAnalysisCollection : NSObject

@property (nonatomic, strong) SCAFloatAnalysis *temperValue;
@property (nonatomic, strong) SCAFloatAnalysis *composureMeter;
@property (nonatomic, strong) SCAStringAnalysis *temperMeter;
@property (nonatomic, strong) SCACompositStringAnalysis *compositMood;
@property (nonatomic, strong) SCACompositStringAnalysis *moodGroup;

/**
 * Method name: initWithDictionary
 * Description: Initialize with dictionary from server response
 * Parameters:  dictionary - dictionary from server response
 */
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
