//
//  UIView+Frame.m
//
//  Created by Mike Johnson on 8/27/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//
// original source
// http://iobjectivesee.com/2012/03/11/essential-uiview-additions/

#import "UIView+Frame.h"

@implementation UIView (Frame)
	

#pragma mark - Public Methods

- (id) initWithSize:(CGSize)size { return [self initWithFrame:CGRectMake( 0, 0, size.width, size.height )]; }

#pragma mark - Properties

- (CGFloat) left { return self.frame.origin.x; }
- (void) setLeft:(CGFloat)x { CGRect frame = self.frame; frame.origin.x = x; self.frame = frame; }

- (CGFloat) top { return self.frame.origin.y; }
- (void) setTop:(CGFloat)y { CGRect frame = self.frame; frame.origin.y = y; self.frame = frame; }

- (CGFloat) right { return self.frame.origin.x + self.frame.size.width; }
- (void) setRight:(CGFloat)right { CGRect frame = self.frame; frame.origin.x = right - frame.size.width; self.frame = frame; }

- (CGFloat) bottom { return self.frame.origin.y + self.frame.size.height; }
- (void) setBottom:(CGFloat)bottom { CGRect frame = self.frame; frame.origin.y = bottom - frame.size.height; self.frame = frame;}

- (CGFloat) width { return self.frame.size.width; }
- (void) setWidth:(CGFloat)width { CGRect frame = self.frame; frame.size.width = width; self.frame = frame; }

- (CGFloat) height { return self.frame.size.height; }
- (void) setHeight:(CGFloat)height { CGRect frame = self.frame; frame.size.height = height; self.frame = frame; }

- (CGPoint) origin { return self.frame.origin; }
- (void) setOrigin:(CGPoint)origin { CGRect frame = self.frame; frame.origin = origin; self.frame = frame; }

- (CGSize) size { return self.frame.size; }
- (void) setSize:(CGSize)size { CGRect frame = self.frame; frame.size = size; self.frame = frame; }

- (CGFloat) centerX { return self.center.x; }
- (void) setCenterX:(CGFloat)x { CGPoint c = self.center; c.x = x; self.center = c; }

- (CGFloat) centerY { return self.center.y; }
- (void) setCenterY:(CGFloat)y { CGPoint c = self.center; c.y = y; self.center = c; }

@end
