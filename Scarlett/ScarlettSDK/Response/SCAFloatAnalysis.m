//
//  SCAFloatAnalysis.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAFloatAnalysis.h"

@implementation SCAFloatAnalysis

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        self.value = [[dictionary objectForKey:@"value"] floatValue];
    }
    return self;
}

@end
