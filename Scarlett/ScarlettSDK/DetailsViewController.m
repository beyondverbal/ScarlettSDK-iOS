//
//  DetailsViewController.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/29/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "DetailsViewController.h"

@implementation DetailsViewController

-(id)initWithEmotionsAnalyzerSession:(SCAEmotionsAnalyzerSession*)emotionsAnalyzerSession segment:(SCASegment*)segment
{
    if(self = [super init])
    {
        self.emotionsAnalyzerSession = emotionsAnalyzerSession;
        self.segment = segment;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SCAAnalysisCollection *analysis = self.segment.analysis;
    
    if(analysis.compositMood)
    {
        self.lblCompositMoodPrimary.text = analysis.compositMood.value.primary;
        self.lblCompositMoodSecondary.text = analysis.compositMood.value.secondary;
    }
    
    if(analysis.composureMeter)
    {
        self.lblComposureMeter.text = [NSString stringWithFormat:@"%f", analysis.composureMeter.value];
    }
    
    if(analysis.moodGroup)
    {
        self.lblMoodGroupPrimary.text = analysis.moodGroup.value.primary;
        self.lblMoodGroupSecondary.text = analysis.moodGroup.value.secondary;
    }
    
    if(analysis.temperMeter)
    {
        self.lblTemperMeter.text = analysis.temperMeter.value;
        
        BOOL isLow = [analysis.temperMeter isLow];
        BOOL isMed = [analysis.temperMeter isMed];
        BOOL isHigh = [analysis.temperMeter isHigh];
        
        if(isLow)
        {
            self.lblTemperMeter.textColor = [UIColor blueColor];
        }
        else if(isMed)
        {
            self.lblTemperMeter.textColor = [UIColor greenColor];
        }
        else if(isHigh)
        {
            self.lblTemperMeter.textColor = [UIColor redColor];
        }
    }
    
    if(analysis.temperValue)
    {
        self.lblTemperValue.text = [NSString stringWithFormat:@"%f", analysis.temperValue.value];
    }
}

-(IBAction)btnGetSummary_Pressed:(id)sender
{
    
}

-(IBAction)btnVote_Pressed:(id)sender
{
    
}

#pragma mark - Response delegates

-(void)getSummarySucceed:(SCAAnalysisResult*)summaryResult
{
    
}

-(void)getSummaryFailed:(NSString*)errorDescription
{
    
}

-(void)voteSucceed:(SCAVoteResult*)voteResult
{
    
}

-(void)voteFailed:(NSString*)errorDescription
{
    
}

@end
