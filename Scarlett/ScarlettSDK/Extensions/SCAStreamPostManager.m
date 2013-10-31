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

-(id)initWithDelegate:(id<SCAStreamPostManagerDelegate>)delegate requestTimeout:(NSTimeInterval)requestTimeout isDebug:(BOOL)isDebug
{
    if(self = [super init])
    {
        self.delegate = delegate;
        self.isDebug = isDebug;
        self.requestTimeout = requestTimeout;
        self.postData = [[NSMutableData alloc] init];

        self.bufferOnHeap = malloc(kPostBufferSize);
        self.buffer = self.bufferOnHeap;
        
        self.bufferOffset = 0;
        self.bufferLimit  = 0;
        
        self.isSending = NO;
    }
    return self;
}

-(void)startSend:(NSString*)url
{
    [self startSend:url inputStream:nil];
}

-(void)startSend:(NSString *)url inputStream:(NSInputStream*)inputStream
{
    if(self.isDebug)
    {
        NSLog(@"startSend %@", url);
    }
    
    self.isSending = YES;
    
    NSURL *                 myURL = [NSURL URLWithString:url];
    NSMutableURLRequest *   request;
    
    if(!inputStream)
    {
        NSInputStream *         consStream;
        NSOutputStream *        prodStream;
        
        [NSStream createBoundInputStream:&consStream outputStream:&prodStream bufferSize:kPostBufferSize];
        
        self.consumerStream = consStream;
        self.producerStream = prodStream;
        
        self.producerStream.delegate = self;
        [self.producerStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.producerStream open];
    }
    
    request = [NSMutableURLRequest requestWithURL:myURL];
    request.timeoutInterval = self.requestTimeout;
    
    [request setHTTPMethod:@"POST"];
    
    if(!inputStream)
    {
        [request setHTTPBodyStream:self.consumerStream];
    }
    else
    {
        [request setHTTPBodyStream:inputStream];
    }
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(inputStream)
    {
        [self.connection start];
    }
}

-(void)stopSend
{
    if(self.isSending)
    {
        if(self.isDebug)
        {
            NSLog(@"stopSend");
        }
        
        self.isSending = NO;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForNewPostDataToWrite) object:nil];
        
        if (self.bufferOnHeap)
        {
            free(self.bufferOnHeap);
            self.bufferOnHeap = NULL;
        }
        
        self.buffer = NULL;
        self.bufferOffset = 0;
        self.bufferLimit  = 0;
        
        if (self.connection != nil)
        {
            [self.connection cancel];
            self.connection = nil;
        }
        
        if (self.producerStream != nil)
        {
            self.producerStream.delegate = nil;
            [self.producerStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.producerStream close];
        }
        
        self.consumerStream = nil;
        
        [self.delegate streamStopped];
    }
}

-(void)appendPostData:(NSData*)data
{
    [self.postData appendData:[data copy]];
    
    if(self.isDebug)
    {
        NSLog(@"appendPostData %d", [data length]);
    }
}

// An NSStream delegate callback that's called when events happen on our
// network stream.
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    assert(aStream == self.producerStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            if(self.isDebug)
            {
                NSLog(@"Producer stream opened");
            }
            break;
            
        case NSStreamEventHasBytesAvailable:
            if(self.isDebug)
            {
                NSLog(@"Producer stream has bytes available");
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            [self checkForNewPostDataToWrite];
            break;
            
        case NSStreamEventErrorOccurred:
            if(self.isDebug)
            {
                NSLog(@"Producer stream error %@", [aStream streamError]);
            }
            [self stopSend];
            [self.delegate streamFailed:@"Stream open error"];
            break;
            
        case NSStreamEventEndEncountered:
            if(self.isDebug)
            {
                NSLog(@"Producer stream ended");
            }
            break;
            
        default:
            break;
    }
}
                 
-(void)checkForNewPostDataToWrite
{
    if(!self.isSending)
    {
        return;
    }
    
    if (self.bufferOffset == self.bufferLimit)
    {
        NSUInteger postDataLength = [self.postData length];
        
        if(self.isDebug)
        {
            NSLog(@"postDataLength %d", postDataLength);
        }
        
        if(postDataLength > 0)
        {
            NSUInteger bytesRead = postDataLength;
            
            if(bytesRead > kPostBufferSize)
            {
                bytesRead = kPostBufferSize;
            }
            
            [self.postData getBytes:self.bufferOnHeap length:bytesRead];
            
            NSUInteger bytesLeft = postDataLength - bytesRead;
            
            NSData *subData = [self.postData subdataWithRange:NSMakeRange(bytesRead, bytesLeft)];
            
            self.postData = [NSMutableData dataWithData:subData];
            
            self.bufferOffset = 0;
            self.bufferLimit  = bytesRead;
        }
    }
    
    // Send the next chunk of data in our buffer.
    if (self.bufferOffset != self.bufferLimit)
    {
        NSInteger bytesWritten = [self.producerStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
        
        if(self.isDebug)
        {
            NSLog(@"bytesWritten %d", bytesWritten);
        }
        
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
