//
//  EXPullToRefresh.h
//
//  Created by Mike Johnson on 6/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

// PREREQUISITES:
// QuartzCore.framework is required to be included in the project.
//
// 
// DELEGATE CALLBACK USAGE:
// [mytableview addPullToRefreshWithDelegate:self];
//
// -- OR --
// 
// BLOCK CALLBACK USAGE:
// __block typeof (self) weakself = self;
// [mytable addPullToRefreshWithBlock:^(EXPullToRefresh *refreshControl) { [weakself refreshData]; }];


#import <UIKit/UIKit.h>

@protocol EXPullToRefreshDelegate <NSObject>

- (void) pullToRefreshTriggered;

@end

@interface EXPullToRefresh : UIView

@property (nonatomic, strong) id <EXPullToRefreshDelegate> delegate;

- (id) initWithScrollView:(UIScrollView *)myscroll;
- (void) triggerRefresh;
- (void) stopAnimating;
- (void) startAnimating; // used if you need to manually trigger showing
- (void) setColor:(UIColor *)newColor;
- (void) setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)newStyle;

@end

@interface UIScrollView (EXPullToRefresh) <EXPullToRefreshDelegate>

@property (nonatomic, readonly) EXPullToRefresh *pullToRefresh;

- (void) addPullToRefreshWithBlock:(void (^)(EXPullToRefresh *refreshControl))block;
- (void) addPullToRefreshWithDelegate:(id)d;
//- (EXPullToRefresh *) pullToRefreshView;

@end
