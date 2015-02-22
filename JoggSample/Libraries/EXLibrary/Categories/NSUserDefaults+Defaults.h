//
//  NSUserDefaults+Defaults.h
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Defaults)

- (id) objectForKey:(NSString *)defaultName withDefaultValue:(id)defaultValue;
- (BOOL) boolForKey:(NSString *)defaultName withDefaultValue:(BOOL)defaultValue;
- (int) intForKey:(NSString *)defaultName withDefaultValue:(int)defaultValue;

@end
