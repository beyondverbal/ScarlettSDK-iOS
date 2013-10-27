//
//  SCAAnalysisResult.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAAnalysisResult : NSObject

@property (nonatomic) unsigned long durationProcessed;
@property (nonatomic, strong) NSArray *analysisSegments;

-(id)initWithResponseData:(NSData*)responseData;

@end
