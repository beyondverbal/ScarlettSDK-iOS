//
//  SCAStartSessionResult.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAFollowupActions.h"
#import "SCAResponseStatuses.h"

@interface SCAStartSessionResult : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) SCAFollowupActions *followupActions;

/**
 * Method name: initWithDictionary
 * Description: Initialize with dictionary from server response
 * Parameters:  dictionary - dictionary from server response
 */
-(id)initWithResponseData:(NSData*)responseData;

/**
 * Method name: isSucceed
 * Description: Checks if start session succeeded
 */
-(BOOL)isSucceed;

@end
