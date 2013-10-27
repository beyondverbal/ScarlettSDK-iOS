//
//  SCAStartSessionResponderDelegate.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCASummaryResponderDelegate <NSObject>
-(void)getSummarySucceed:(NSData*)responseData;
-(void)getSummaryFailed:(NSError*)error;
@end
