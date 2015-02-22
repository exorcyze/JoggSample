//
//  EXNotificationView.m
//  EXLibrary
//
//  Created by Mike Johnson on 1/29/13.
//  Copyright (c) 2013 Mike Johnson. All rights reserved.
//

#import "EXNotificationView.h"
#import "EXMacros.h"
#import "UIView+Frame.h"

#define NOTIFICATION_HEIGHT 60
#define NOTIFICATION_WIDTH 300

@interface EXNotificationView ()
- (void) setup;
- (void) hide;
@end

static BOOL isShowing;

@implementation EXNotificationView {
	UIWindow *window;
	UIView *backgroundView;
	UILabel *messageLabel;
}

#pragma mark - Lifecycle Methods

- (id) init {
	self = [super init];
	if ( self ) {
		[self setup];
	}
	return self;
}

#pragma mark - Public Methods

- (void) showNotificationWithMessage:(NSString *)message {
	if ( isShowing ) { return; }
	isShowing = YES;
	
	window = [[UIWindow alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_SIZE_ORIENTED.width, NOTIFICATION_HEIGHT ) ];
	window.windowLevel = UIWindowLevelStatusBar;
	window.backgroundColor = [UIColor clearColor];
	BOOL isLeft = [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft;
	BOOL isRight = [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight;
	if ( isLeft ) { window.transform = CGAffineTransformMakeRotation( -M_PI/2 ); }
	if ( isRight ) { window.transform = CGAffineTransformMakeRotation( M_PI/2 ); }
	
	backgroundView.height = 0;
	messageLabel.text = message;

	[UIView animateWithDuration:0.5 animations:^{
		backgroundView.height = NOTIFICATION_HEIGHT;
	}];
	
	[window addSubview:self];
	[window makeKeyAndVisible];
	
	[self performSelector:@selector(hide) withObject:nil afterDelay:4.0];
}

#pragma mark - Private Methods

- (void) setup {
	
	isShowing = NO;
	
	UIColor *backgroundColor = [UIColor colorFromHex:0x87dc80 withAlpha:1.0];
	backgroundView = [UIView viewWithFrame:CGRectMake( 0, 0, SCREEN_SIZE_ORIENTED.width, NOTIFICATION_HEIGHT ) andBackgroundColor:backgroundColor];
	backgroundView.clipsToBounds = YES;
	//[backgroundView setCornerRadius:4 withBorderColor:[UIColor blackColor] andBorderSize:2];
	[self addSubview:backgroundView];
	
	messageLabel = [UILabel labelWithFont:[UIFont fontWithName:@"Scada" size:16] andFrame:backgroundView.bounds andColor:[UIColor whiteColor]];
	messageLabel.textAlignment = NSTextAlignmentCenter;
	messageLabel.numberOfLines = 0;
	[messageLabel setShadowColor:[UIColor colorFromHex:0x3a3a3a withAlpha:0.5] withOffset:CGSizeMake( 0, -1 )];
	[backgroundView addSubview:messageLabel];
	
}

- (void) hide {
	isShowing = NO;
	
	[UIView animateWithDuration:0.5 animations:^{
		backgroundView.height = 0;
	} completion:^(BOOL finished) {
		window.hidden = YES;
		window = nil;
	}];
}

#pragma mark - Event Responders


@end
