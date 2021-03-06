//
//  SCAVoteResult.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/27/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAResponseStatuses.h"

@interface SCAVoteResult : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *result;

/**
 * Method name: initWithResponseData
 * Description: Initialize with response from server
 * Parameters:  responseData - response data from server
 */
-(id)initWithResponseData:(NSData*)responseData;

@end
