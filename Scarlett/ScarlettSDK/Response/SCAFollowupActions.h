//
//  SCAFollowupActions.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAFollowupActions : NSObject

@property (nonatomic, strong) NSString *upStream;
@property (nonatomic, strong) NSString *analysis;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *vote;

/**
 * Method name: initWithDictionary
 * Description: Initialize with dictionary from server response
 * Parameters:  dictionary - dictionary from server response
 */
-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
