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

-(id)initWithDelegate:(id<SCAStreamPostManagerDelegate>)delegate requestTimeout:(NSTimeInterval)requestTimeout;
-(void)startSend:(NSString*)url;
-(void)startSend:(NSString *)url inputStream:(NSInputStream*)inputStream;
-(void)stopSend;
-(void)appendPostData:(NSData*)data;

@end
