//
//  NSUserDefaults+Defaults.m
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "NSUserDefaults+Defaults.h"

@implementation NSUserDefaults (Defaults)

- (id) objectForKey:(NSString *)defaultName withDefaultValue:(id)defaultValue {
	if ( [self objectForKey:defaultName] ==  nil ) { return defaultValue; }
	else { return [self objectForKey:defaultName]; }
}

- (BOOL) boolForKey:(NSString *)defaultName withDefaultValue:(BOOL)defaultValue {
	if ( [self objectForKey:defaultName] ==  nil ) { return defaultValue; }
	else { return [self boolForKey:defaultName]; }
}

- (int) intForKey:(NSString *)defaultName withDefaultValue:(int)defaultValue {
	if ( [self objectForKey:defaultName] ==  nil ) { return defaultValue; }
	else { return (int)[self integerForKey:defaultName]; }
}

@end
