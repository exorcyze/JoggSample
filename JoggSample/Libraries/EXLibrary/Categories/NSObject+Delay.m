//
//  NSObject+Delay.m
//
//  Created by Mike Johnson on 11/24/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "NSObject+Delay.h"
#import <objc/runtime.h>

@implementation NSObject (Delay)

#pragma mark - Public Methods

- (void) afterDelay:(NSTimeInterval)delay performBlock:(void (^)(void))block {
	objc_setAssociatedObject(self, "blockCallback", [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self performSelector:@selector(executeCallback) withObject:nil afterDelay:delay];
}

#pragma mark - Callback Methods

- (void) executeCallback {
	//NSLog( @"executing callback" );
	void (^block)(void) = objc_getAssociatedObject(self, "blockCallback");
	block();
}

@end
