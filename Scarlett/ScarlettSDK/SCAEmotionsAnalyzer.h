//
//  EmotionsAnalyzer.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/28/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCASessionParameters.h"
#import "SCAEmotionsAnalyzerSessionDelegate.h"
#import "SCAEmotionsAnalyzerSession.h"

@interface SCAEmotionsAnalyzer : NSObject

/**
 * Method name: initializeSession
 * Description: Return new session object
 * Parameters:  sessionParameters - parameters for the session such recording data format, recorder info and types required to analysis
 *              apiKey - Scarlett api key (in case of nil - it will be read from plist file)
 *              plistFileName - full file name including ".plist" to read api key from
 *              requestTimeout - timeout for the url requests such get analysis, summary request and vote request
 *              getAnalysisTimeInterval - interval to wait between each get analysis request
 *              host - kEmotionAnalysisHostBeta or kEmotionAnalysisHostProduction
 *              sessionDelegate - delegate object that responds to session events
 */
+(SCAEmotionsAnalyzerSession*)initializeSession:(SCASessionParameters*)sessionParameters
                                         apiKey:(NSString*)apiKey
                                  plistFileName:(NSString*)plistFileName
                                 requestTimeout:(NSTimeInterval)requestTimeout
                        getAnalysisTimeInterval:(NSTimeInterval)getAnalysisTimeInterval
                                           host:(NSString*)host
                                sessionDelegate:(id<SCAEmotionsAnalyzerSessionDelegate>)sessionDelegate;

@end
