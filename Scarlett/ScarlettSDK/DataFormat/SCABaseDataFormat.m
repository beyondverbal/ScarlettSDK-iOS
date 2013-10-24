//
//  SCABaseDataFormat.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCABaseDataFormat.h"

@implementation SCABaseDataFormat

-(id)initWithSampleRate:(int)sampleRate
          bitsPerSample:(int)bitsPerSample
               channels:(int)channels
{
    if(self = [super init])
    {
        self.sampleRate = sampleRate;
        self.bitsPerSample = bitsPerSample;
        self.channels = channels;
    }
    return self;
}

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[self audioEncodingFormatString] forKey:@"type"];
    [dictionary setObject:[NSNumber numberWithInt:self.channels] forKey:@"channels"];
    [dictionary setObject:[NSNumber numberWithInt:self.sampleRate] forKey:@"sample_rate"];
    [dictionary setObject:[NSNumber numberWithInt:self.bitsPerSample] forKey:@"bits_per_sample"];
    
    return dictionary;
}

-(NSString*)audioEncodingFormatString
{
    NSString *formatTypeString;
    
    switch (self.formatType)
    {
        case kAudioEncodingFormatPCM:
            formatTypeString = @"pcm";
            break;
            
        case kAudioEncodingFormatWAV:
            formatTypeString = @"wav";
            break;
            
        default:
            @throw([NSException exceptionWithName:@"Unknown format" reason:@"Must implement new format" userInfo:nil]);
            break;
    }
    
    return  formatTypeString;
}

@end
