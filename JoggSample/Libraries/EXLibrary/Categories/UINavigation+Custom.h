//
//  UINavigation+Custom.h
//  EviteMe
//
//  Created by Mike Johnson on 10/24/11.
//  Copyright (c) 2011 Evite. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NAVIGATION_LOGO_TAG 999
#define SHADOW_TAG 1000

@interface UINavigation_Custom : NSObject

@end

@interface UINavigationBar (Custom)
@end

@interface UINavigationController (Custom)
- (UIBarButtonItem *)createNavigationButtonForImage:(NSString *)defaultState withDisabledState:(NSString *)disabledState withSelector:(SEL)selector;
@end

@interface UIBarButtonItem (Custom)
+ (UIBarButtonItem *)buttonWithImage:(NSString *)imageName andDisabledImage:(NSString *)disabledName andSelector:(SEL)myselector onTarget:(id)target;
@end
