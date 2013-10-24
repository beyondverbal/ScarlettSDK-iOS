//
//  NSStream_BoundPairAdditions.h
//  SimpleURLConnections
//
//  Created by Daniel Galeev on 10/22/13.
//
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <unistd.h>
#include <CFNetwork/CFNetwork.h>

@interface NSStream (BoundPairAdditions)

+ (void)createBoundInputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr bufferSize:(NSUInteger)bufferSize;

@end
