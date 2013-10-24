//
//  SCAStreamPostManager.m
//  SimpleURLConnections
//
//  Created by Daniel Galeev on 10/22/13.
//
//

#import "SCAStreamPostManager.h"

const NSTimeInterval kCheckForNewPostDataToWrite = 2.0;

@implementation SCAStreamPostManager

-(id)initWithDelegate:(id<SCAStreamPostManagerDelegate>)delegate
{
    if(self = [super init])
    {
        self.delegate = delegate;
        self.postData = [[NSMutableData alloc] init];

        self.bufferOnHeap = malloc(kPostBufferSize);
        self.buffer = self.bufferOnHeap;
        
        self.bufferOffset = 0;
        self.bufferLimit  = 0;
        
//        NSString *boundaryString = [self generateBoundaryString];
//        NSString *bodyPrefixString = [NSString stringWithFormat:
//                         @
//                         "\r\n"
//                         "--%@\r\n"
//                         "Content-Disposition: form-data; name=\"fileContents\"; filename=\"%@.wav\"\r\n"
//                         "Content-Type: %@\r\n"
//                         "\r\n",
//                         boundaryString,
//                         boundaryString,
//                         @"audio/x-wav"
//                         ];
//        self.bodyPrefixData = [bodyPrefixString dataUsingEncoding:NSASCIIStringEncoding];
//        self.buffer      = [self.bodyPrefixData bytes];
//        self.bufferLimit = [self.bodyPrefixData length];
    }
    return self;
}

- (NSString *)generateBoundaryString
{
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

-(void)startSend:(NSString*)url
{
    NSURL *                 myURL = [NSURL URLWithString:url];
    NSMutableURLRequest *   request;
    NSInputStream *         consStream;
    NSOutputStream *        prodStream;
    
//    assert(self.connection == nil);         // don't tap send twice in a row!
//    assert(self.bodyPrefixData == nil);     // ditto
//    assert(self.fileStream == nil);         // ditto
//    assert(self.bodySuffixData == nil);     // ditto
//    assert(self.consumerStream == nil);     // ditto
//    assert(self.producerStream == nil);     // ditto
//    assert(self.buffer == NULL);            // ditto
//    assert(self.bufferOnHeap == NULL);      // ditto
    
    // Open producer/consumer streams.  We open the producerStream straight
    // away.  We leave the consumerStream alone; NSURLConnection will deal
    // with it.
    
    [NSStream createBoundInputStream:&consStream outputStream:&prodStream bufferSize:kPostBufferSize];
    assert(consStream != nil);
    assert(prodStream != nil);
    self.consumerStream = consStream;
    self.producerStream = prodStream;
    
    self.producerStream.delegate = self;
    [self.producerStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.producerStream open];
    
    // Open a connection for the URL, configured to POST the file.
    request = [NSMutableURLRequest requestWithURL:myURL];
    request.timeoutInterval = 100000; //TODO: check how to make infinite timeout
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBodyStream:self.consumerStream];
    
//    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=\"%@\"", boundaryStr] forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%llu", bodyLength] forHTTPHeaderField:@"Content-Length"];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    assert(self.connection != nil);
}

-(void)stopSend
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForNewPostDataToWrite) object:nil];
    
    if (self.bufferOnHeap)
    {
        free(self.bufferOnHeap);
        self.bufferOnHeap = NULL;
    }
    
    self.buffer = NULL;
    self.bufferOffset = 0;
    self.bufferLimit  = 0;
    
//    if (self.connection != nil)
//    {
//        [self.connection cancel];
//        self.connection = nil;
//    }
    
    self.bodyPrefixData = nil;
    
    if (self.producerStream != nil)
    {
        self.producerStream.delegate = nil;
        [self.producerStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.producerStream close];
//        self.producerStream = nil;
    }
    
    self.consumerStream = nil;
    self.bodySuffixData = nil;
}

-(void)appendPostData:(NSData*)data
{
    [self.postData appendData:[data copy]];
    
    NSLog(@"**************** appendPostData %d", [data length]);
}

// An NSStream delegate callback that's called when events happen on our
// network stream.
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    assert(aStream == self.producerStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"producer stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            assert(NO);     // should never happen for the output stream
            break;
            
        case NSStreamEventHasSpaceAvailable:

            [self checkForNewPostDataToWrite];
            
//            // Check to see if we've run off the end of our buffer.  If we have,
//            // work out the next buffer of data to send.
//            
//            if (self.bufferOffset == self.bufferLimit)
//            {
//                NSUInteger postDataLength = [self.postData length];
//                
//                NSLog(@"---------- postDataLength %d --------------", postDataLength);
//                
//                if(postDataLength > 0)
//                {
//                    NSUInteger bytesRead = postDataLength;
//                    
//                    if(bytesRead > kPostBufferSize)
//                    {
//                        bytesRead = kPostBufferSize;
//                    }
//                    
//                    [self.postData getBytes:self.bufferOnHeap length:bytesRead];
//                    
//                    NSUInteger bytesLeft = postDataLength - bytesRead;
//                    
//                    NSLog(@"---------- bytesRead-bytesLeft %d-%d", bytesRead, bytesLeft);
//                    NSLog(@"---------- postData %d", [self.postData length]);
//                    
//                    NSData *subData = [self.postData subdataWithRange:NSMakeRange(bytesRead, bytesLeft)];
//                    
//                    self.postData = [NSMutableData dataWithData:subData];
//                    
//                    NSLog(@"---------- postData %d", [self.postData length]);
//
//                    self.bufferOffset = 0;
//                    self.bufferLimit  = bytesRead;
//                }
//            }
//            
//            // Send the next chunk of data in our buffer.
//            if (self.bufferOffset != self.bufferLimit)
//            {
//                NSInteger bytesWritten = [self.producerStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
//                
//                NSLog(@"---------- bytesWritten %d --------------", bytesWritten);
//                
//                if (bytesWritten <= 0)
//                {
//                    [self stopSend];
//                    [self.delegate streamFailed:@"Network write error"];
//                }
//                else
//                {
//                    self.bufferOffset += bytesWritten;
//                }
//            }
//            else
//            {
//                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForNewPostDataToWrite) object:nil];
//                [self performSelector:@selector(checkForNewPostDataToWrite) withObject:nil afterDelay:kCheckForNewPostDataToWrite];
//            }
            
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"producer stream error %@", [aStream streamError]);
            [self stopSend];
            [self.delegate streamFailed:@"Stream open error"];
            break;
            
        case NSStreamEventEndEncountered:
            //assert(NO);     // should never happen for the output stream
            break;
            
        default:
            //assert(NO);
            break;
    }
}
                 
-(void)checkForNewPostDataToWrite
{
    if (self.bufferOffset == self.bufferLimit)
    {
        NSUInteger postDataLength = [self.postData length];
        
        NSLog(@"222 ---------- postDataLength %d --------------", postDataLength);
        
        if(postDataLength > 0)
        {
            NSUInteger bytesRead = postDataLength;
            
            if(bytesRead > kPostBufferSize)
            {
                bytesRead = kPostBufferSize;
            }
            
            [self.postData getBytes:self.bufferOnHeap length:bytesRead];
            
            NSUInteger bytesLeft = postDataLength - bytesRead;
            
            NSLog(@"222 ---------- bytesRead-bytesLeft %d-%d", bytesRead, bytesLeft);
            NSLog(@"222 ---------- postData %d", [self.postData length]);
            
            NSData *subData = [self.postData subdataWithRange:NSMakeRange(bytesRead, bytesLeft)];
            
            self.postData = [NSMutableData dataWithData:subData];
            
            NSLog(@"222 ---------- postData %d", [self.postData length]);
            
            self.bufferOffset = 0;
            self.bufferLimit  = bytesRead;
        }
    }
    
    // Send the next chunk of data in our buffer.
    if (self.bufferOffset != self.bufferLimit)
    {
        NSInteger bytesWritten = [self.producerStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
        
        NSLog(@"222 ---------- bytesWritten %d --------------", bytesWritten);
        
        if (bytesWritten <= 0)
        {
            [self stopSend];
            [self.delegate streamFailed:@"Network write error"];
        }
        else
        {
            self.bufferOffset += bytesWritten;
        }
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForNewPostDataToWrite) object:nil];
        [self performSelector:@selector(checkForNewPostDataToWrite) withObject:nil afterDelay:kCheckForNewPostDataToWrite];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    
    if ((httpResponse.statusCode / 100) != 2)
    {
        NSString *errorDescription = [NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode];
        
        [self stopSend];
        [self.delegate streamFailed:errorDescription];
    }
    else
    {
        self.responseData = [[NSMutableData alloc] init];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate streamFailed:[error localizedDescription]];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate streamSucceed:self.responseData];
}

@end
