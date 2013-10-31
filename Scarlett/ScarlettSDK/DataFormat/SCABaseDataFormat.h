//
//  SCABaseDataFormat.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAAudioEncodingFormat.h"

@interface SCABaseDataFormat : NSObject

@property (nonatomic) SCAAudioEncodingFormat formatType;
@property (nonatomic) int channels;
@property (nonatomic) int sampleRate;
@property (nonatomic) int bitsPerSample;
@property (nonatomic) BOOL autoDetect;

/**
 * Method name: initWithSampleRate
 * Description: Iniialize data format with sample rate, bits per sample and number of channels
 * Parameters:  sampleRate - sample rate, 8,000 for best results
 *              bitsPerSample - bits per sample, 16 for best results
 *              channels - number of the channels
 */
-(id)initWithSampleRate:(int)sampleRate
          bitsPerSample:(int)bitsPerSample
               channels:(int)channels;

/**
 * Method name: toDictionary
 * Description: Convert parameters to dictionary
 */
-(NSMutableDictionary*)toDictionary;

@end
