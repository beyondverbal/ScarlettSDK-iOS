//
//  SCAWavDataFormat.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAWavDataFormat.h"

@implementation SCAWavDataFormat

-(id)initWithSampleRate:(int)sampleRate
          bitsPerSample:(int)bitsPerSample
               channels:(int)channels
{
    if(self = [super initWithSampleRate:sampleRate bitsPerSample:bitsPerSample channels:channels])
    {
        self.formatType = kAudioEncodingFormatWAV;
    }
    return self;
}

@end
