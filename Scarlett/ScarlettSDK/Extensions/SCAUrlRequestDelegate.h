//
//  SCAUrlRequestDelegate.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCAUrlRequestDelegate <NSObject>

-(void)loadUrlSucceed:(NSData*)responseData;
-(void)loadUrlFailed:(NSError*)error;

@end
