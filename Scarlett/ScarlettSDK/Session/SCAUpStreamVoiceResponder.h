//
//  SCAUpStreamVoiceResponder.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAUpStreamVoiceResponderDelegate.h"
#import "SCAStreamPostManagerDelegate.h"

@interface SCAUpStreamVoiceResponder : NSObject<SCAStreamPostManagerDelegate>

@property (nonatomic, weak) id<SCAUpStreamVoiceResponderDelegate> delegate;

@end
