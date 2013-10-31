//
//  SCAStreamPostManager.h
//  SimpleURLConnections
//
//  Created by Daniel Galeev on 10/22/13.
//
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <unistd.h>
#include <CFNetwork/CFNetwork.h>
#import "NSStream_BoundPairAdditions.h"
#import "SCAStreamPostManagerDelegate.h"

enum
{
    kPostBufferSize = 32000 //32768
};

@interface SCAStreamPostManager : NSObject<NSStreamDelegate>

@property (nonatomic) BOOL isSending;
@property (nonatomic) NSTimeInterval requestTimeout;
@property (nonatomic, strong, readwrite) NSURLConnection *connection;
@property (nonatomic, copy,   readwrite) NSData *bodyPrefixData;
@property (nonatomic, strong, readwrite) NSInputStream *fileStream;
@property (nonatomic, copy,   readwrite) NSData *bodySuffixData;
@property (nonatomic, strong, readwrite) NSOutputStream *producerStream;
@property (nonatomic, strong, readwrite) NSInputStream *consumerStream;
@property (nonatomic, assign, readwrite) const uint8_t *buffer;
@property (nonatomic, assign, readwrite) uint8_t *bufferOnHeap;
@property (nonatomic, assign, readwrite) size_t bufferOffset;
@property (nonatomic, assign, readwrite) size_t bufferLimit;
@property (nonatomic, strong) NSMutableData *postData;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) id<SCAStreamPostManagerDelegate> delegate;

/**
 * Method name: initWithDelegate
 * Description: Initialize stream post manager object responsible of streaming audio data to server
 * Parameters:  delegate - delegate object that responds to streaming events
 *              requestTimeout - timeout for the request
 */
-(id)initWithDelegate:(id<SCAStreamPostManagerDelegate>)delegate requestTimeout:(NSTimeInterval)requestTimeout;

/**
 * Method name: startSend
 * Description: Initialize voice data streaming
 * Parameters:  url - request url to stream voice data
 */
-(void)startSend:(NSString*)url;

/**
 * Method name: startSend
 * Description: Initialize stream from file (or any other input stream)
 * Parameters:  url - request url to stream voice data
 *              inputStream - input stream (can use to stream from file)
 */
-(void)startSend:(NSString *)url inputStream:(NSInputStream*)inputStream;

/**
 * Method name: stopSend
 * Description: Stops streaming the data
 */
-(void)stopSend;

/**
 * Method name: appendPostData
 * Description: Adds voice data to stream
 * Parameters:  data - new voice data
 */
-(void)appendPostData:(NSData*)data;

@end
