//
//  SCAHeirarchyStringAnalysis.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAHeirarchyStringAnalysis.h"

@implementation SCAHeirarchyStringAnalysis

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    if(self = [super init])
    {
        self.primary = [dictionary objectForKey:@"Primary"];
        self.secondary = [dictionary objectForKey:@"Secondary"];
    }
    return self;
}

@end
