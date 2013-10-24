//
//  SCAUrlRequest.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCAUrlRequest.h"

@implementation SCAUrlRequest

-(void)loadWithUrl:(NSString*)url
              body:(NSData*)body
   timeoutInterval:(NSTimeInterval)timeoutInterval
          isStream:(BOOL)isStream
        httpMethod:(NSString*)httpMethod
          delegate:(id<SCAUrlRequestDelegate>)delegate

{
    self.delegate = delegate;
    
    NSURL *myURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:timeoutInterval];
    
    [request setHTTPMethod:httpMethod];
    
    if(!isStream)
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:body];
    }
    else
    {
        NSInputStream *inputStream = [NSInputStream inputStreamWithData:body];
        [request setHTTPBodyStream:inputStream];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate loadUrlFailed:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate loadUrlSucceed:self.responseData];
}

@end
