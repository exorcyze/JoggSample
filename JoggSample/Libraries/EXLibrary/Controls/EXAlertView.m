//
//  EXAlertView.m
//
//  Created by Mike Johnson on 1/29/13.
//  Copyright (c) 2013 Exorcyze Studios. All rights reserved.
//

#import "EXAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Frame.h"
#import "EXMacros.h"

@interface EXAlertView ()
- (void) setupViews;
- (UIButton *) createButtonWithTitle:(NSString *)mytitle;
@end

static BOOL isShowing;

#define EXAlertPadding CGSizeMake( 10, 20 )
#define BASE_BUTTON_TAG 99

@implementation EXAlertView {
	UIWindow *window;
	
	void (^returnBlock)(NSUInteger buttonIndex, EXAlertView *alertView);
	
	UILabel *titleLabel;
	UILabel *messageLabel;
	NSMutableArray *buttons;
}

@synthesize title;
@synthesize message;

#pragma mark - Static Methods

+ (EXAlertView *) alertViewWithTitle:(NSString *)newTitle andMessage:(NSString *)newMessage {
	EXAlertView *myalert = [[EXAlertView alloc] init];
	myalert.title = newTitle;
	myalert.message = newMessage;
	return myalert;
}

#pragma mark - Lifecycle Methods

- (id) init {
	self = [super initWithFrame:CGRectMake( 0, 0, 300, 300) ];
	if ( self ) {
		[self setupViews];
	}
	return self;
}

- (void) layoutSubviews {
	titleLabel.origin = CGPointMake( EXAlertPadding.width, EXAlertPadding.height );
	titleLabel.width = self.width - titleLabel.left - EXAlertPadding.width;
	messageLabel.origin = CGPointMake( EXAlertPadding.width, titleLabel.bottom + EXAlertPadding.height );
	messageLabel.width = titleLabel.width;
	messageLabel.height = [message heightOfTextForWidth:messageLabel.width withFont:messageLabel.font andLineBreakMode:NSLineBreakByWordWrapping];
	
	int offsetWidth = self.width / ( buttons.count + 1 );
	UIButton *mybutton;
	for ( int i = 0; i < buttons.count; i++ ) {
		mybutton = [buttons objectAtIndex:i];
		mybutton.top = messageLabel.bottom + EXAlertPadding.height;
		mybutton.centerX = offsetWidth * ( i + 1 );
	}
	
	self.height = mybutton.bottom + EXAlertPadding.height;
}

#pragma mark - Property Overrides

- (void) setTitle:(NSString *)newTitle {
	title = newTitle;
	titleLabel.text = title;
}
- (void) setMessage:(NSString *)newMessage {
	message = newMessage;
	messageLabel.text = message;
	
	[self layoutSubviews];
}

#pragma mark - Public Methods

- (void) setButtonTitles:(NSArray *)newTitles {
	for ( UIButton *mybutton in buttons ) { [mybutton removeFromSuperview]; }
	[buttons removeAllObjects];
	
	for ( int i = 0; i < newTitles.count; i++ ) {
		NSString *mytitle = [newTitles objectAtIndex:i];
		UIButton *mybutton = [self createButtonWithTitle:mytitle];
		mybutton.tag = BASE_BUTTON_TAG + i;
		[self addSubview:mybutton];
		[buttons addObject:mybutton];
		
		
	}
	[self layoutSubviews];
}

- (void) showWithReturnBlock:(void (^)(NSUInteger buttonIndex, EXAlertView *alertView))block {
	returnBlock = block;
	[self show];
}

- (void) show {
	
	if ( isShowing ) { return; }
	isShowing = YES;
	
	CGRect frame = [UIScreen mainScreen].bounds;
	BOOL isLeft = [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft;
	BOOL isRight = [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight;
	if ( isLeft || isRight ) { frame.size.width = frame.size.height; }
	
	window = [[UIWindow alloc] initWithFrame:frame];
	window.windowLevel = UIWindowLevelAlert;
	window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
	
	self.center = CGPointMake(CGRectGetMidX(window.bounds), CGRectGetMidY(window.bounds));
	
	if ( isLeft ) { window.transform = CGAffineTransformMakeRotation( -M_PI/2 ); }
	if ( isRight ) { window.transform = CGAffineTransformMakeRotation( M_PI/2 ); }
	
	[window addSubview:self];
	[window makeKeyAndVisible];
	
	self.center = CGPointMake( self.center.x, self.center.y + 100 );
	if ( isLeft ) { self.center = CGPointMake( self.center.x, self.center.y - 100 ); }
	if ( isRight ) { self.center = CGPointMake( self.center.x, self.center.y + 100 ); }
	
	self.alpha = 0;
	self.transform = CGAffineTransformMakeScale( 0.5, 0.5 );
	CGAffineTransform mytransform = CGAffineTransformMakeScale( 1.0, 1.0 );
	[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.center = CGPointMake( self.center.x, self.center.y - 100 );
		self.alpha = 1;
		self.transform = mytransform;
	} completion:^(BOOL finished) {
	}];
	
}
- (void) hide {
	isShowing = NO;
	
	CGAffineTransform mytransform = CGAffineTransformMakeScale( 0.5, 0.5 );
	[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.center = CGPointMake( self.center.x, self.center.y + 100 );
		self.transform = mytransform;
	} completion:^(BOOL finished) {
		window.hidden = YES;
		window = nil;
	}];
}

#pragma mark - Private Methods

- (void) setupViews {
	self.backgroundColor = COLOR_BACKGROUND;
	self.clipsToBounds = YES;
	self.layer.borderColor = COLOR_BORDER.CGColor;
	self.layer.borderWidth = 3;
	self.layer.cornerRadius = 10;
	
	buttons = [[NSMutableArray alloc] init];
	
	titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:14] andFrame:CGRectMake( 0, 0, self.width, 16 ) andColor:COLOR_TEXT];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:titleLabel];
	messageLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:12] andFrame:CGRectMake( 0, titleLabel.bottom + 12, self.width, 16 ) andColor:COLOR_TEXT];
	messageLabel.textAlignment = NSTextAlignmentCenter;
	messageLabel.numberOfLines = 0;
	messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
	[self addSubview:messageLabel];
	
	[self setButtonTitles:[NSArray arrayWithObjects:@"OK", nil] ];
}

- (UIButton *) createButtonWithTitle:(NSString *)mytitle {
	CGSize mysize = CGSizeMake( 80, 30 );
	
	//UIImage *gradientImage = [UIImage imageOfSize:mysize withGradientFromBaseColor:[UIColor colorFromHex:0x3f3f3f]];
	UIImage *gradientImage = [UIImage imageOfSize:mysize withGradientFromBaseColor:COLOR_BUTTON andCornerRadius:4 andBorderWidth:1];
	
	UIButton *mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	mybutton.frame = CGRectMake( 0, 0, mysize.width, mysize.height );
	[mybutton setBackgroundColor:[UIColor clearColor]];
	[mybutton setBackgroundImage:gradientImage forState:UIControlStateNormal];
	[mybutton setTitleColor:COLOR_TEXT forState:UIControlStateNormal];
	[mybutton setTitle:mytitle forState:UIControlStateNormal];
	[mybutton setTitleShadowColor:COLOR_BACKGROUND forState:UIControlStateNormal];
	[mybutton.titleLabel setShadowOffset:CGSizeMake( 0, -1 )];
	[mybutton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
	mybutton.layer.cornerRadius = 4;
	//mybutton.layer.borderColor = [[UIColor colorFromHex:0x3f3f3f] colorDarkenedByPercent:0.4].CGColor;
	//mybutton.layer.borderWidth = 1;
	mybutton.clipsToBounds = YES;
	[mybutton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	return mybutton;
}

#pragma mark - Event Responders

- (void) buttonClicked:(id)sender {
	if ( returnBlock ) {
		UIButton *mybutton = (UIButton *)sender;
		returnBlock( mybutton.tag - BASE_BUTTON_TAG, self );
	}
	[self hide];
}

@end
