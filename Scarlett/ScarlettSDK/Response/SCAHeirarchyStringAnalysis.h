//
//  SCAHeirarchyStringAnalysis.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAHeirarchyStringAnalysis : NSObject

@property (nonatomic, strong) NSString *primary;
@property (nonatomic, strong) NSString *secondary;

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
