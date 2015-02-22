//
//  NSInvocation+Creation.m
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "NSInvocation+Creation.h"

@implementation NSInvocation (Creation)

+ (id)invocationWithSelector:(SEL)selector target:(id)target arguments:(id<NSObject>)firstObject, ... { 
	
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
	
    [invocation setTarget:target];
    [invocation setSelector:selector];
	
    id eachObject;
    va_list argumentList;
    int index = 2; // should start at 2 since 0 and 1 is reserved _self and _cmd
	
    // The first argument isn't part of the varargs list
    if (firstObject) {
        [invocation setArgument:&firstObject atIndex:index];
        index ++;
		
        // Start scanning for arguments after firstObject.
        va_start(argumentList, firstObject); 
		
        // As many times as we can get an argument of type "id"
        while ((eachObject = va_arg(argumentList, id))) { 
            [invocation setArgument:&eachObject atIndex:index];
            index ++; // Increase index  
        }
        va_end(argumentList);
    }
	
    NSAssert(index == [[invocation methodSignature] numberOfArguments], @"you should have same number of arguments as methodsselector");
	
    return invocation;
}

@end
