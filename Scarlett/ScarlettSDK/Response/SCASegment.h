//
//  SCASegment.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAAnalysisCollection.h"

@interface SCASegment : NSObject

@property (nonatomic) unsigned long offset;
@property (nonatomic) unsigned long duration;
@property (nonatomic, strong) SCAAnalysisCollection *analysis;

/**
 * Method name: initWithDictionary
 * Description: Initialize with dictionary from server response
 * Parameters:  dictionary - dictionary from server response
 */
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
