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

/**
 * Method name: initWithDataFormat
 * Description: Initialize with data format, recorder info and required analysis types
 * Parameters:  dataFormat - recording data format
 *              recorderInfo - information about recorder (such email, phone, device info, ...)
 *              requiredAnalysisTypes - required analysis types
 */
-(id)initWithDataFormat:(SCABaseDataFormat*)dataFormat recorderInfo:(SCARecorderInfo*)recorderInfo requiredAnalysisTypes:(SCARequiredAnalysis*)requiredAnalysisTypes;

/**
 * Method name: dataFormatToDictionary
 * Description: Convert data format to dictionary
 */
-(NSMutableDictionary*)dataFormatToDictionary;

/**
 * Method name: dataFormatToDictionary
 * Description: Convert recorder info to dictionary
 */
-(NSMutableDictionary*)recorderInfoToDictionary;

/**
 * Method name: dataFormatToDictionary
 * Description: Convert required analysis types to dictionary
 */
-(NSArray*)requiredAnalysisTypesArray;

@end
