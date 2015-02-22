//
//  NSInvocation+Creation.h
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//
// original source:
// http://stackoverflow.com/questions/5375127/what-is-the-easiest-way-to-init-create-make-an-nsinvocation-with-target-sel

#import <Foundation/Foundation.h>

@interface NSInvocation (Creation)

+ (id)invocationWithSelector:(SEL)selector target:(id)target arguments:(id)firstArgument, ...;

@end
