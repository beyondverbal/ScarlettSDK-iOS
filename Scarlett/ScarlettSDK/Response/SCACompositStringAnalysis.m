//
//  SCACompositStringAnalysis.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCACompositStringAnalysis.h"

@implementation SCACompositStringAnalysis

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        self.value = [[SCAHeirarchyStringAnalysis alloc] initWithDictionary:[dictionary objectForKey:@"value"]];
    }
    return self;
}

@end
