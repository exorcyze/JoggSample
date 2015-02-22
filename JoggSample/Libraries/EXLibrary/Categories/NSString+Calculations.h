//
//  NSString+Calculations.h
//
//  Created by Jane Mitchell on 2/10/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Calculations)

- (float) heightOfTextForWidth:(float)width withFont:(UIFont *)withFont andLineBreakMode:(NSLineBreakMode)lineBreakMode;
- (float) widthOfTextForHeight:(float)height withFont:(UIFont *)withFont andLineBreakMode:(NSLineBreakMode)lineBreakMode;
- (float) widthForLabel:(UILabel *)mylabel;
- (float) heightForLabel:(UILabel *)mylabel;
- (float) heightForTextView:(UITextView *)mytext;

- (NSString *) getFirstUrlString;
+ (NSString *) base64String:(NSString *)str;
- (NSData*) sha1;
- (NSString *) trimmedString;
- (BOOL) containsWhitespace;

@end
