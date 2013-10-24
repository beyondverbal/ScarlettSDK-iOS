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

-(id)initWithSampleRate:(int)sampleRate
          bitsPerSample:(int)bitsPerSample
               channels:(int)channels;

-(NSMutableDictionary*)toDictionary;

@end
