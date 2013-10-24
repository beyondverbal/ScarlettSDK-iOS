//
//  SCASessionParameters.m
//  Scarlett
//
//  Created by Daniel Galeev on 10/20/13.
//  Copyright (c) 2013 BeyondVerbals. All rights reserved.
//

#import "SCASessionParameters.h"

@implementation SCASessionParameters

-(id)initWithDataFormat:(SCABaseDataFormat*)dataFormat recorderInfo:(SCARecorderInfo*)recorderInfo requiredAnalysisTypes:(SCARequiredAnalysis*)requiredAnalysisTypes
{
    if(self = [super init])
    {
        _dataFormat = dataFormat;
        _recorderInfo = recorderInfo;
        _requiredAnalysisTypes = requiredAnalysisTypes;
    }
    return self;
}

-(NSMutableDictionary*)dataFormatToDictionary
{
    return [_dataFormat toDictionary];
}

-(NSMutableDictionary*)recorderInfoToDictionary
{
    return [_recorderInfo toDictionary];
}

-(NSArray*)requiredAnalysisTypesArray
{
    return _requiredAnalysisTypes.requiredAnalisys;
}

@end
