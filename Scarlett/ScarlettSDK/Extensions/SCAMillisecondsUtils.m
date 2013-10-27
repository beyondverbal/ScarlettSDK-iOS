//
//  MillisecondsUtils.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/21/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAMillisecondsUtils.h"

@implementation SCAMillisecondsUtils

+(float)getMilliseconds
{
    return milliseconds();
}

float milliseconds()
{
    static uint64_t firstTick = 0;
    static mach_timebase_info_data_t info;
    
    if (firstTick == 0)
    {
        mach_timebase_info(&info);
        firstTick = mach_absolute_time();
    }
    
    return (float)(mach_absolute_time() * info.numer / info.denom  / 1000000.0);
}

@end
