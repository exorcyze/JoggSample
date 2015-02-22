//
//  NSDate+Conversions.h
//
//  Created by Jane Mitchell on 2/6/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Conversions)

- (NSString *) getRelativeTimeDescription;
- (NSString *) getRelativeTimeShortDescription;
- (NSDate *) parseLocalFromGMT;
- (NSDate *) parseGMTFromLocal;
- (NSString *) getStringUsingFormat:(NSString *)format;
+ (NSDate *) dateFromString:(NSString *)string usingFormat:(NSString *)format;

@end
