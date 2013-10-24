//
//  SCAVote.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAVote : NSObject

@property (nonatomic) int offset;
@property (nonatomic) int duration;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic) int voteScore;
@property (nonatomic, strong) NSString *verbalVote;

@end
