//
//  UINavigation+Custom.m
//  EviteMe
//
//  Created by Mike Johnson on 10/24/11.
//  Copyright (c) 2011 Evite. All rights reserved.
//

#import "UINavigation+Custom.h"
#import "UIColor+Extensions.h"

@implementation UINavigation_Custom
@end

@implementation UINavigationBar (Custom)

- (void)drawRect:(CGRect)rect {
	if ( [self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) { return; }
	
	UIImage *image = [UIImage imageNamed:@"background-navbar.png"];
	[image drawInRect:rect];
}

@end

@implementation UINavigationController (Custom)

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] } forState:UIControlStateNormal];
	[[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
	self.navigationBar.tintColor = [UIColor whiteColor];
	[self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navigationBar.translucent = NO;
	self.navigationBar.barTintColor = COLOR_TITLE_BAR;
	self.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
	[[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] } forState:UIControlStateNormal];
	[[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
	self.navigationBar.tintColor = [UIColor whiteColor];
	[self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
	
	return;
	
	if ( [self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
		//[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
		//[[UINavigationBar appearance] setTintColor:COLOR_MENU_HIGHLIGHT];
		//[[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
		
		//if ( [self isKindOfClass:[MFMailComposeViewController class]] ) { return; }
		
		//[self.navigationBar setBackgroundImage:[UIImage imageWithColor:COLOR_TITLE_BAR andCornerRadius:0] forBarMetrics:UIBarMetricsDefault];
		[self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andCornerRadius:0] forBarMetrics:UIBarMetricsDefault];
		
		UIFont *font = [UIFont fontWithName:FONT_NAME_TITLE_BOLD size:20];
		//UIColor *color = [UIColor whiteColor];
		NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
		[attr setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
		[attr setObject:font forKey:NSFontAttributeName];
		/*
		NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:font, UITextAttributeFont,
							  [UIColor blackColor], UITextAttributeTextColor,
							  [UIColor clearColor], UITextAttributeTextShadowColor,
							  CGPointMake( 0, 0 ), UITextAttributeTextShadowOffset, nil];
		 */
		[self.navigationBar setTitleTextAttributes:attr];
		
	}
}

- (UIBarButtonItem *)createNavigationButtonForImage:(NSString *)defaultState withDisabledState:(NSString *)disabledState withSelector:(SEL)selector {
	UIImage *defaultImage = [UIImage imageNamed:defaultState];
	UIImage *disabledImage = [UIImage imageNamed:disabledState];
	
	UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:defaultImage forState:UIControlStateNormal];
	[button setImage:disabledImage forState:UIControlStateDisabled];
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	[button setFrame:CGRectMake( 0, 0, defaultImage.size.width, defaultImage.size.height )];
	return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end

@implementation UIBarButtonItem (Custom)

+ (UIBarButtonItem *)buttonWithImage:(NSString *)imageName andDisabledImage:(NSString *)disabledName andSelector:(SEL)myselector onTarget:(id)target {
	UIImage *defaultImage = [UIImage imageNamed:imageName];
	UIImage *disabledImage = [UIImage imageNamed:disabledName];
	
	UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:defaultImage forState:UIControlStateNormal];
	[button setImage:disabledImage forState:UIControlStateDisabled];
	[button addTarget:target action:myselector forControlEvents:UIControlEventTouchUpInside];
	[button setFrame:CGRectMake( 0, 0, defaultImage.size.width, defaultImage.size.height )];
	return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end