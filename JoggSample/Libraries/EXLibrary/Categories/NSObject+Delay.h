//
//  NSObject+Delay.h
//
//  Created by Mike Johnson on 11/24/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Delay)

- (void) afterDelay:(NSTimeInterval)delay performBlock:(void (^)(void))block;

@end
