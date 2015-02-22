//
//  NSString+Calculations.m
//
//  Created by Jane Mitchell on 2/10/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "NSString+Calculations.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Calculations)

/**
 heightOfTextForWidth
 Description : Returns the needed height to contain the current text
 given a width, font and line break mode.
 Usage : float myheight = [myString heightOfTextForWidth:300 withFont:[UIFont systemFontOfSize:12] andLineBreakMode:UILineBreakModeWordWrap];
 */
- (float) heightOfTextForWidth:(float)width withFont:(UIFont *)withFont andLineBreakMode:(NSLineBreakMode)lineBreakMode {
	//CGSize suggestedSize = [self sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	CGRect suggestedSize = [self boundingRectWithSize:CGSizeMake( width, 0 ) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:withFont} context:nil];
	return suggestedSize.size.height;
}

- (float) widthOfTextForHeight:(float)height withFont:(UIFont *)withFont andLineBreakMode:(NSLineBreakMode)lineBreakMode {
	//CGSize suggestedSize = [self sizeWithFont:withFont constrainedToSize:CGSizeMake(FLT_MAX, height) lineBreakMode:lineBreakMode];
	CGRect suggestedSize = [self boundingRectWithSize:CGSizeMake( 0, height ) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:withFont} context:nil];
	return suggestedSize.size.width;
}

- (float) widthForLabel:(UILabel *)mylabel {
	return [self widthOfTextForHeight:mylabel.height withFont:mylabel.font andLineBreakMode:mylabel.lineBreakMode];
}
- (float) heightForLabel:(UILabel *)mylabel {
	return [self heightOfTextForWidth:mylabel.width withFont:mylabel.font andLineBreakMode:mylabel.lineBreakMode];
}

- (float) heightForTextView:(UITextView *)mytext {
	return [self heightOfTextForWidth:mytext.width - 10 withFont:mytext.font andLineBreakMode:NSLineBreakByWordWrapping];
}

/**
 Description : Returns the first URL found in the string. Returns nil if http:// not found.
*/
- (NSString *) getFirstUrlString {
	NSString *mytext = self;
	long loc = [mytext rangeOfString:@"http://"].location;
	if ( loc == NSNotFound ) { return nil; }
	
	long end = [mytext rangeOfString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange( loc, mytext.length - loc ) ].location;
	if ( end == NSNotFound ) { end = mytext.length; }
	NSString *ret = [mytext substringWithRange:NSMakeRange( loc, end - loc )];
	return ret;
}

// SOURCE : http://www.calebmadrigal.com/string-to-base64-string-in-objective-c/
+ (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
			
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSData*) sha1 {
	//	const char *cStr = [self UTF8String];
	//	unsigned char result[20];
	//	CC_SHA1(cStr, strlen(cStr), result);
	//
	//	return [NSData dataWithBytes:result length:20];
	
	NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
	
	unsigned char digest[20];
	CC_SHA1(data.bytes, (unsigned int)data.length, digest);
	
	return [NSData dataWithBytes:digest length:20];
}

- (NSString *) trimmedString {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL) containsWhitespace {
	if ( IS_EMPTY_STRING( self ) ) { return NO; }
	return !NSEqualRanges( [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]], NSMakeRange( NSNotFound, 0 ) );
}

@end
