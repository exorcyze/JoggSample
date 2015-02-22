//
//  NSDate+Conversions.m
//
//  Created by Jane Mitchell on 2/6/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "NSDate+Conversions.h"

@implementation NSDate (Conversions)

/**
 getRelativeTimeDescription
 Description: Returns a description of the time difference 
 between the current date and the passed NSDate.
 IE: "3 days ago"
 */
- (NSString *) getRelativeTimeDescription {
	NSDate *today = [NSDate date];
	NSDate *startDate = self;
	int interval = round( [startDate timeIntervalSinceDate:today] ) * -1;
	NSString *ret = NSLocalizedString( @"never", @"" );
	
	if ( interval < 1 ) { ret = NSLocalizedString( @"never", @"" ); }
	if ( interval < 60 ) { ret = NSLocalizedString( @"just now", @"" ); }
	if ( interval > 60 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i min ago", @"" ), (int)round( interval / 60 )]; }
	if ( interval > 60 * 60 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i hour(s) ago", @"" ), (int)round( interval / 60 / 60 )]; }
	if ( interval > 60 * 60 * 24 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i day(s) ago", @"" ), (int)round( interval / 60 / 60 / 24 )]; }
	if ( interval > 60 * 60 * 24 * 7 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i week(s) ago", @"" ), (int)round( interval / 60 / 60 / 24 / 7 )]; }
	if ( interval > 60 * 60 * 24 * 7 * 4 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i month(s) ago", @"" ), (int)round( interval / 60 / 60 / 24 / 7 / 4 )]; }
	if ( interval > 60 * 60 * 24 * 7 * 4 * 52 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i year(s) ago", @"" ), (int)round( interval / 60 / 60 / 24 / 7 / 4 / 52 )]; }
	
	return ret;
}

/**
 getRelativeTimeShortDescription
 Description: Returns a description of the time difference
 between the current date and the passed NSDate.
 IE: "3 d"
 */
- (NSString *) getRelativeTimeShortDescription {
	NSDate *today = [NSDate date];
	NSDate *startDate = self;
	int interval = round( [startDate timeIntervalSinceDate:today] ) * -1;
	NSString *ret = NSLocalizedString( @"--", @"" );
	
	if ( interval < 1 ) { ret = NSLocalizedString( @"--", @"" ); }
	if ( interval < 60 ) { ret = NSLocalizedString( @"< 1 m", @"" ); }
	if ( interval > 60 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i m", @"" ), (int)round( interval / 60 )]; }
	if ( interval > 60 * 60 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i h", @"" ), (int)round( interval / 60 / 60 )]; }
	if ( interval > 60 * 60 * 24 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i d", @"" ), (int)round( interval / 60 / 60 / 24 )]; }
	if ( interval > 60 * 60 * 24 * 7 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i w", @"" ), (int)round( interval / 60 / 60 / 24 / 7 )]; }
	//if ( interval > 60 * 60 * 24 * 7 * 4 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i month(s) ago", @"" ), (int)round( interval / 60 / 60 / 24 / 7 / 4 )]; }
	if ( interval > 60 * 60 * 24 * 7 * 4 * 52 ) { ret = [NSString stringWithFormat:NSLocalizedString( @"%i y", @"" ), (int)round( interval / 60 / 60 / 24 / 7 / 4 / 52 )]; }
	
	return ret;
}

- (NSDate *) parseLocalFromGMT {
	NSTimeZone *tz = [NSTimeZone defaultTimeZone];
	NSInteger seconds = [tz secondsFromGMTForDate:self];
	return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSDate *) parseGMTFromLocal {
	NSTimeZone *tz = [NSTimeZone defaultTimeZone];
	NSInteger seconds = -[tz secondsFromGMTForDate:self];
	return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

// Returns a readable string from a date.
// Usage : NSString *mystring = [[NSDate date] getStringUsingFormat:@"yyyy-MM-dd' 'HH:mm:SS"];
// Date format patterns : http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
- (NSString *) getStringUsingFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	return timestamp_str;
}

// Parses a date from a given string using the passed format.
// Usage : NSDate *mydate = [NSDate dateFromString:@"2013-02-06 05:23:41" usingFormat:@"yyyy-MM-dd' 'HH:mm:SS"];
// Date format patterns : http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
+ (NSDate *) dateFromString:(NSString *)string usingFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];
	return date;
}

@end
