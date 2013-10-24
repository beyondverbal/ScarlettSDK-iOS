//
//  SCAUrlRequest.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAUrlRequestDelegate.h"

@interface SCAUrlRequest : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, weak) id<SCAUrlRequestDelegate> delegate;
@property (nonatomic, strong) NSMutableData *responseData;

-(void)loadWithUrl:(NSString*)url
              body:(NSData*)body
   timeoutInterval:(NSTimeInterval)timeoutInterval
          isStream:(BOOL)isStream
        httpMethod:(NSString*)httpMethod
          delegate:(id<SCAUrlRequestDelegate>)delegate;

@end
