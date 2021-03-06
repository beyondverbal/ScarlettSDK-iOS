//
//  DetailsViewController.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/29/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCASegment.h"
#import "SCAEmotionsAnalyzerSession.h"

@interface DetailsViewController : UIViewController<SCAEmotionsAnalyzerSummaryDelegate, SCAEmotionsAnalyzerVoteDelegate>

@property (nonatomic, strong) SCAEmotionsAnalyzerSession *emotionsAnalyzerSession;
@property (nonatomic, strong) SCASegment *segment;
@property (nonatomic) BOOL getSummaryInProgress;
@property (nonatomic) BOOL voteInProgress;

@property (nonatomic, strong) IBOutlet UILabel *lblCompositMoodPrimary;
@property (nonatomic, strong) IBOutlet UILabel *lblCompositMoodSecondary;
@property (nonatomic, strong) IBOutlet UILabel *lblComposureMeter;
@property (nonatomic, strong) IBOutlet UILabel *lblMoodGroupPrimary;
@property (nonatomic, strong) IBOutlet UILabel *lblMoodGroupSecondary;
@property (nonatomic, strong) IBOutlet UILabel *lblTemperMeter;
@property (nonatomic, strong) IBOutlet UILabel *lblTemperValue;

/**
 * Method name: initWithEmotionsAnalyzerSession
 * Description: Initialize analysis details view
 * Parameters:  emotionsAnalyzerSession - analysis session object to call get summary and vote
 *              segment - analysis segment
 */
-(id)initWithEmotionsAnalyzerSession:(SCAEmotionsAnalyzerSession*)emotionsAnalyzerSession segment:(SCASegment*)segment;

/**
 * Method name: btnClose_Pressed
 * Description: Close view
 */
-(IBAction)btnClose_Pressed:(id)sender;

/**
 * Method name: btnGetSummary_Pressed
 * Description: Get summary request
 */
-(IBAction)btnGetSummary_Pressed:(id)sender;

/**
 * Method name: btnVote_Pressed
 * Description: Execute vote request
 */
-(IBAction)btnVote_Pressed:(id)sender;

@end
