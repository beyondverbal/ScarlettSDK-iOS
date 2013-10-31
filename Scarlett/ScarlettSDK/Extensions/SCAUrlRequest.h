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

/**
 * Method name: loadWithUrl
 * Description: Initialize url request
 * Parameters:  url - request url
 *              body - request body (json parameters)
 *              isStream - choose between json and stream request
 *              httpMethod - POST or GET
 *              delegate - delegate object that responds to request events
 */
-(void)loadWithUrl:(NSString*)url
              body:(NSData*)body
   timeoutInterval:(NSTimeInterval)timeoutInterval
          isStream:(BOOL)isStream
        httpMethod:(NSString*)httpMethod
          delegate:(id<SCAUrlRequestDelegate>)delegate;

@end
