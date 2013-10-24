//
//  SCAStartSessionResponderDelegate.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCAStartSessionResponderDelegate <NSObject>
-(void)startSessionSucceed:(NSData*)responseData;
-(void)startSessionFailed:(NSError*)error;
@end
