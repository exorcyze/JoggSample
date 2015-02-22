//
//  EXPullToRefresh.m
//
//  Created by Mike Johnson on 6/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "EXPullToRefresh.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

enum {
	EXPullToRefreshStateHidden = 0,
	EXPullToRefreshStateVisible,
	EXPullToRefreshStateTriggered,
	EXPullToRefreshStateLoading
};

@interface EXPullToRefresh ()

- (void) updateDisplayForState;
- (void) scrollViewDidScroll:(CGPoint)contentOffset;

@end


@implementation EXPullToRefresh {
	UIScrollView *scrollView;
	UILabel *titleLabel;
	UILabel *arrowLabel;
	UIActivityIndicatorView *activity;
	
	UIEdgeInsets originalContentInset;
	int currentState;
	BOOL wasStartedManually;
}

@synthesize delegate;

// DELEGATE METHOD - (void) pullToRefreshTriggered;

#pragma mark - View Lifecycle

- (id) initWithScrollView:(UIScrollView *)myscroll {
	self = [super initWithFrame:CGRectZero];
	if ( self ) {
		currentState = EXPullToRefreshStateHidden;
		wasStartedManually = NO;
		
		scrollView = myscroll;
		[scrollView addSubview:self];
		originalContentInset = scrollView.contentInset;
		
		titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:14] andFrame:CGRectMake( 40, 20, 150, 20 ) andColor:[UIColor darkGrayColor] ];
		titleLabel.text = @"Pull to refresh...";
		[self addSubview:titleLabel];
		
		arrowLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:42] andFrame:CGRectMake( 0, 0, 30, 60 ) andColor:[UIColor darkGrayColor]];
		arrowLabel.text = @"\u2193";
		arrowLabel.layer.anchorPoint = CGPointMake( 0.5, 0.5 );
		[self addSubview:arrowLabel];
		
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activity.layer.anchorPoint = CGPointMake( 0, 0 );
        activity.hidesWhenStopped = YES;
        [self addSubview:activity];
		
		self.frame = CGRectMake( 0, -60, scrollView.bounds.size.width, 60 );
		
		[scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
		[scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
	}
	return self;
}

- (void)dealloc {
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [scrollView removeObserver:self forKeyPath:@"frame"];
}

- (void) layoutSubviews {
	activity.center = CGPointMake( 10, 17 );
	arrowLabel.center = CGPointMake( 20, 25 );
}

#pragma mark - Observer Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( [keyPath isEqualToString:@"contentOffset"] ) { [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]]; }
    else if ( [keyPath isEqualToString:@"frame"] ) { [self layoutSubviews]; }
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
	if ( !delegate ) { return; }
	if ( currentState == EXPullToRefreshStateLoading ) { return; }
	
	CGFloat scrollOffsetThreshold = self.frame.origin.y - originalContentInset.top;
	if ( !scrollView.isDragging && currentState == EXPullToRefreshStateTriggered ) { currentState = EXPullToRefreshStateLoading; }
	else if ( contentOffset.y > scrollOffsetThreshold && contentOffset.y < -originalContentInset.top && scrollView.isDragging && currentState != EXPullToRefreshStateLoading ) { currentState = EXPullToRefreshStateVisible; }
	else if ( contentOffset.y < scrollOffsetThreshold && scrollView.isDragging && currentState == EXPullToRefreshStateVisible ) { currentState = EXPullToRefreshStateTriggered; }
	else if ( contentOffset.y >= -originalContentInset.top && currentState != EXPullToRefreshStateHidden ) { currentState = EXPullToRefreshStateHidden; }
	[self updateDisplayForState];
}

#pragma mark - Private Methods

- (void) updateDisplayForState {
	NSArray *titles = [NSArray arrayWithObjects:@"Pull to refresh...", @"Pull to refresh...", @"Release to refresh...", @"Loading...", nil];
	titleLabel.text = [titles objectAtIndex:currentState];
	
	if ( currentState == EXPullToRefreshStateLoading ) { [activity startAnimating]; }
	else { [activity stopAnimating]; }
	
	if ( currentState != EXPullToRefreshStateTriggered ) {
		UIEdgeInsets contentInset = originalContentInset;
		if ( currentState == EXPullToRefreshStateLoading ) {
			contentInset.top = self.frame.origin.y * -1 + originalContentInset.top;
			contentInset.bottom = scrollView.contentInset.bottom;
		}
		[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
			scrollView.contentInset = contentInset;
		} completion:^(BOOL finished) {
			if ( currentState == EXPullToRefreshStateHidden && contentInset.top == originalContentInset.top ) {
				[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{ arrowLabel.alpha = 0; } completion:NULL];
			}
		}];
	}
	
	if ( currentState == EXPullToRefreshStateLoading && !wasStartedManually && [delegate respondsToSelector:@selector(pullToRefreshTriggered)] ) {
		[delegate pullToRefreshTriggered];
	}
	
	float degrees = ( currentState == EXPullToRefreshStateTriggered ) ? M_PI : 0;
	float alpha = ( currentState == EXPullToRefreshStateLoading ) ? 0 : 1;
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		arrowLabel.layer.transform = CATransform3DMakeRotation( degrees, 0, 0, 1 );
		arrowLabel.layer.opacity = alpha;
	} completion:NULL];
}

#pragma mark - Public Methods

- (void) triggerRefresh {
	currentState = EXPullToRefreshStateLoading;
	[self updateDisplayForState];
}
- (void) stopAnimating {
	wasStartedManually = NO;
	currentState = EXPullToRefreshStateHidden;
	[self updateDisplayForState];
}
- (void) startAnimating {
	wasStartedManually = YES;
	currentState = EXPullToRefreshStateLoading;
	[self updateDisplayForState];
}

- (void) setColor:(UIColor *)newColor {
	arrowLabel.textColor = newColor;
	titleLabel.textColor = newColor;
	
}
- (void) setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)newStyle {
	activity.activityIndicatorViewStyle = newStyle;
}

@end


#pragma mark - =================================
#pragma mark - UIScrollView (EVPullToRefresh)

@implementation UIScrollView (EVPullToRefresh)

- (void) addPullToRefreshWithBlock:(void (^)(EXPullToRefresh *refreshControl))block {
	// http://oleb.net/blog/2011/05/faking-ivars-in-objc-categories-with-associative-references/
	EXPullToRefresh *refresh = [[EXPullToRefresh alloc] initWithScrollView:self];
	refresh.delegate = self;
	objc_setAssociatedObject(self, "pullToRefresh", refresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, "pullToRefreshBlock", [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void) addPullToRefreshWithDelegate:(id)d {
	// http://oleb.net/blog/2011/05/faking-ivars-in-objc-categories-with-associative-references/
	EXPullToRefresh *refresh = [[EXPullToRefresh alloc] initWithScrollView:self];
	refresh.delegate = d;
	objc_setAssociatedObject(self, "pullToRefresh", refresh, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) pullToRefreshTriggered {
	EXPullToRefresh *refresh = objc_getAssociatedObject(self, "pullToRefresh");
	void (^block)(EXPullToRefresh *refreshControl) = objc_getAssociatedObject(self, "pullToRefreshBlock");
	block( refresh );
}
/*
- (EVPullToRefresh *) pullToRefreshView {
	EVPullToRefresh *refresh = objc_getAssociatedObject(self, "pullToRefresh");
	return refresh;
}
*/

- (EXPullToRefresh *) pullToRefresh {
	EXPullToRefresh *refresh = objc_getAssociatedObject(self, "pullToRefresh");
	return refresh;
}

@end

