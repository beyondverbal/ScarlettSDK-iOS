//
//  SCAStartSessionResponderDelegate.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCAAnalysisResponderDelegate <NSObject>
-(void)analysisSucceed:(NSData*)responseData;
-(void)analysisFailed:(NSError*)error;
@end
