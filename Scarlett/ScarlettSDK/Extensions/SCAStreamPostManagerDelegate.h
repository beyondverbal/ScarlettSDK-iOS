//
//  SCAStreamPostManagerDelegate.h
//  SimpleURLConnections
//
//  Created by Daniel Galeev on 10/22/13.
//
//

#import <Foundation/Foundation.h>

@protocol SCAStreamPostManagerDelegate <NSObject>
-(void)streamSucceed:(NSData*)responseData;
-(void)streamFailed:(NSString*)errorDescription;
-(void)streamStopped;
@end
