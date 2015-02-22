//
//  CacheHelper.m
//
//  Created by Mike Johnson on 10/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "CacheHelper.h"

@implementation CacheHelper

+ (void) cacheString:(NSString *)data forKey:(NSString *)key {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", key] ];
	[data writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
	//NSLog( @"SAVING CACHE FOR %@", key );
}

+ (BOOL) hasCacheForKey:(NSString *)key {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", key] ];
	NSString *prefetch = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
	//NSLog( @"CACHE AVAILABLE FOR %@ = %i", key, !IS_EMPTY_STRING( prefetch ) );
	return !IS_EMPTY_STRING( prefetch );
}

+ (NSString *) getCacheForKey:(NSString *)key {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", key] ];
	NSString *prefetch = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
	//NSLog( @"RETRIEVE CACHE FOR %@", key );
	return prefetch;
}

@end
