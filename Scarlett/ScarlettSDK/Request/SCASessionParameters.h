//
//  SCASessionParameters.h
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCABaseDataFormat.h"
#import "SCARecorderInfo.h"
#import "SCARequiredAnalysis.h"

@interface SCASessionParameters : NSObject
{
    SCABaseDataFormat *_dataFormat;
    SCARecorderInfo *_recorderInfo;
    SCARequiredAnalysis *_requiredAnalysisTypes;
}

-(id)initWithDataFormat:(SCABaseDataFormat*)dataFormat recorderInfo:(SCARecorderInfo*)recorderInfo requiredAnalysisTypes:(SCARequiredAnalysis*)requiredAnalysisTypes;
-(NSMutableDictionary*)dataFormatToDictionary;
-(NSMutableDictionary*)recorderInfoToDictionary;
-(NSArray*)requiredAnalysisTypesArray;

@end
