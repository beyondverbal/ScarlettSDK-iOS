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

#pragma mark - IBActions

-(IBAction)btnClose_Pressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnGetSummary_Pressed:(id)sender
{
    if(!self.getSummaryInProgress)
    {
        self.getSummaryInProgress = YES;
    
        [self.emotionsAnalyzerSession getSummary:self];
    }
}

-(IBAction)btnVote_Pressed:(id)sender
{
    if(!self.voteInProgress)
    {
        self.voteInProgress = YES;
        
        int voteScore = 1;
        NSString *verbalVote = @"I like this stuff";
        
        [self.emotionsAnalyzerSession vote:self voteScore:voteScore verbalVote:verbalVote segment:self.segment];
    }
}

#pragma mark - Response delegates

-(void)getSummarySucceed:(SCASummaryResult*)summaryResult
{
    self.getSummaryInProgress = NO;
    
    if(summaryResult.summaryCollection)
    {
        NSMutableString *summaryText = [[NSMutableString alloc] init];
        
        SCASummaryCollection *summaryCollection = summaryResult.summaryCollection;
        
        if(summaryCollection.moodGroupSummary)
        {
            [summaryText appendFormat:@"Primary: %@\n Secondary: %@", summaryCollection.moodGroupSummary.value.primary, summaryCollection.moodGroupSummary.value.secondary];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Summary" message:summaryText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Summary" message:@"No summary recieved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)getSummaryFailed:(NSString*)errorDescription
{
    self.getSummaryInProgress = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting summary" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)voteSucceed:(SCAVoteResult*)voteResult
{
    self.voteInProgress = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vote succeed" message:voteResult.result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)voteFailed:(NSString*)errorDescription
{
    self.voteInProgress = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error voting" message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
