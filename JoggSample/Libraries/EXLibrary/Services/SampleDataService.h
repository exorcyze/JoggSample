//
//  SampleDataService.h
//  EXLibrary
//
//  Created by Mike Johnson on 1/26/13.
//  Copyright (c) 2013 Exorcyze Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDataService.h"

@interface SampleDataService : BaseDataService

- (void) getTwitterResultsForTerm:(NSString *)searchTerm onComplete:(void (^)(NSArray *returnData, NSError *returnError))block;

@end
