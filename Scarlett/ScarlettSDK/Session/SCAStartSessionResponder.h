//
//  SCAStartSessionResponder.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAStartSessionResponderDelegate.h"
#import "SCAUrlRequestDelegate.h"

@interface SCAStartSessionResponder : NSObject<SCAUrlRequestDelegate>

@property (nonatomic, weak) id<SCAStartSessionResponderDelegate> delegate;

@end
