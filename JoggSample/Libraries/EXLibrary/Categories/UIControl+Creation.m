//
//  UIControl+Creation.m
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "UIControl+Creation.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIColor+Extensions.h"
#import "EXMacros.h"
#import "UIView+Frame.h"

@implementation UIControl_Creation
@end

@implementation UIView (Rounding)
- (void) setCornerRadius:(int)radius withBorderColor:(UIColor *)borderColor andBorderSize:(float)borderSize {
	self.layer.cornerRadius = radius;
	self.clipsToBounds = YES;
	self.layer.borderColor = [borderColor CGColor];
	self.layer.borderWidth = borderSize;
}
+ (UIView *) viewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)backgroundColor {
	UIView *myview = [[UIView alloc] initWithFrame:frame];
	myview.backgroundColor = backgroundColor;
	return myview;
}
@end

@implementation UIButton (Creation)
+ (UIButton *)buttonWithTitle:(NSString *)title andSelector:(SEL)myselector onTarget:(id)target {
	UIButton *mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mybutton setBackgroundColor:[UIColor clearColor]];
	[mybutton setTitleColor:[UIColor colorFromHex:0xfff7b9] forState:UIControlStateNormal];
	[mybutton setTitle:title forState:UIControlStateNormal];
	//[mybutton setTitleEdgeInsets:UIEdgeInsetsMake( 30, 0, 0, 0 )];
	//[mybutton setTitleShadowColor:[UIColor colorFromHex:0xfff7b9] forState:UIControlStateNormal];
	[mybutton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
	//mybutton.layer.anchorPoint = CGPointMake( 0, 0 );
	mybutton.frame = CGRectMake( 0, 0, 80, 40 );
	[mybutton addTarget:target action:myselector forControlEvents:UIControlEventTouchUpInside];
	return mybutton;
}
+ (UIButton *)buttonWithImage:(NSString *)imageName andSelector:(SEL)myselector onTarget:(id)target {
	UIImage *myimage = [UIImage imageNamed:imageName];
	UIButton *mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mybutton setBackgroundImage:myimage forState:UIControlStateNormal];
	//mybutton.layer.anchorPoint = CGPointMake( 0, 0 );
	mybutton.frame = CGRectMake( 0, 0, myimage.size.width, myimage.size.height );
	[mybutton addTarget:target action:myselector forControlEvents:UIControlEventTouchUpInside];
	return mybutton;
}
+ (UIButton *)buttonWithImage:(NSString *)imageName disabledImage:(NSString *)disabledImageName andSelector:(SEL)myselector onTarget:(id)target {
	UIImage *myimage = [UIImage imageNamed:imageName];
	UIButton *mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mybutton setBackgroundImage:myimage forState:UIControlStateNormal];
	[mybutton setBackgroundImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];
	mybutton.layer.anchorPoint = CGPointMake( 0, 0 );
	mybutton.frame = CGRectMake( 0, 0, myimage.size.width, myimage.size.height );
	[mybutton addTarget:target action:myselector forControlEvents:UIControlEventTouchUpInside];
	return mybutton;
}
+ (UIButton *)buttonWithTitle:(NSString *)title andBackgroundColor:(UIColor *)backgroundColor andColor:(UIColor *)textColor andCornerRadius:(int)corner {
	UIImage *myimage = [UIImage imageOfSize:CGSizeMake( 40, 40 ) withGradientFromBaseColor:backgroundColor];
	UIButton *mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	[mybutton setBackgroundImage:myimage forState:UIControlStateNormal];
	//mybutton.imageView.contentMode = UIViewContentModeScaleAspectFill;
	[mybutton setContentMode:UIViewContentModeScaleAspectFill];
	mybutton.clipsToBounds = YES;
	mybutton.layer.borderColor = [backgroundColor colorDarkenedByPercent:0.2].CGColor;
	mybutton.layer.borderWidth = 1;
	mybutton.layer.cornerRadius = corner;
	[mybutton setTitleColor:textColor forState:UIControlStateNormal];
	[mybutton setTitle:title forState:UIControlStateNormal];
	return mybutton;
}
+ (UIButton *) flatButtonWithTitle:(NSString *)title andBackgroundColor:(UIColor *)backgroundColor andColor:(UIColor *)textColor {
	//UIImage *myimage = [UIImage imageOfSize:CGSizeMake( 40, 40 ) withGradientFromColor:backgroundColor toColor:backgroundColor];
	UIButton *mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
	//[mybutton setBackgroundImage:myimage forState:UIControlStateNormal];
	[mybutton setBackgroundColor:backgroundColor];
	[mybutton setContentMode:UIViewContentModeScaleAspectFill];
	mybutton.clipsToBounds = YES;
	[mybutton setTitleColor:textColor forState:UIControlStateNormal];
	[mybutton setTitle:title forState:UIControlStateNormal];
	return mybutton;
}
- (void) addActionBlock:(void (^)(UIButton *sender))block {
	objc_setAssociatedObject(self, "blockCallback", [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void) clicked:(UIButton *)sender {
	void (^block)(UIButton *sender) = objc_getAssociatedObject(self, "blockCallback");
	if ( !block ) { return; }
	block( sender );
}

@end

@implementation UILabel (Creation)
+ (UILabel *)labelWithFont:(UIFont *)font andFrame:(CGRect)frame andColor:(UIColor *)color {
	UILabel *mylabel = [[UILabel alloc] initWithFrame:frame];
	mylabel.textColor = color;
	mylabel.backgroundColor = [UIColor clearColor];
	mylabel.font = font;
	mylabel.layer.anchorPoint = CGPointMake( 0, 0 );
	mylabel.center = CGPointMake( frame.origin.x, frame.origin.y );
	mylabel.frame = frame;
	return mylabel;
}
+ (UILabel *)labelWithFont:(UIFont *)font andFrame:(CGRect)frame andColor:(UIColor *)color andShadow:(BOOL)shadow {
	UILabel *mylabel = [[UILabel alloc] initWithFrame:frame];
	mylabel.textColor = color;
	mylabel.backgroundColor = [UIColor clearColor];
	mylabel.font = font;
	mylabel.layer.anchorPoint = CGPointMake( 0, 0 );
	mylabel.center = CGPointMake( frame.origin.x, frame.origin.y );
	mylabel.frame = frame;
	mylabel.shadowColor = [UIColor blackColor];
	mylabel.shadowOffset = CGSizeMake(0, 2);
	return mylabel;
}
- (void) setShadowColor:(UIColor *)shadowColor withOffset:(CGSize)offset {
	self.shadowColor = shadowColor;
	self.shadowOffset = offset;
}
- (float) sizeWidthForContent {
	float w = [self.text widthOfTextForHeight:self.height withFont:self.font andLineBreakMode:self.lineBreakMode];
	self.width = w;
	return w;
}
@end

@implementation UITextField (Creation)
+ (UITextField *)textFieldWithFont:(UIFont *)font andFrame:(CGRect)frame andPlaceholder:(NSString *)placeholder {
	UITextField *mytext = [[UITextField alloc] initWithFrame:frame];
	mytext.font = font;
	mytext.placeholder = placeholder;
	//mytext.layer.anchorPoint = CGPointMake( 0, 0 );
	//mytext.center = CGPointMake( 0, 0 );
	mytext.frame = frame;
	return mytext;
}
@end

@implementation UITextView (Creation)
+ (UITextView *) textViewWithFont:(UIFont *)font andFrame:(CGRect)frame {
	UITextView *mytext = [[UITextView alloc] initWithFrame:frame];
	mytext.editable = YES;
	mytext.font = font;
	mytext.frame = frame;
	return mytext;
}
@end

@implementation UIImageView (Creation)
+ (UIImageView *) imageViewWithImageNamed:(NSString *)imageName {
	UIImage *myimage = [UIImage imageNamed:imageName];
	UIImageView *myview = [[UIImageView alloc] initWithImage:myimage];
	myview.layer.anchorPoint = CGPointMake( 0, 0 );
	myview.center = CGPointMake( 0, 0 );
	myview.userInteractionEnabled = YES;
	return myview;
}
@end

@implementation UIImage (Creation)
+ (UIImage *) imageWithColor:(UIColor *)color andCornerRadius:(int)radius {
	if ( radius == 0 ) { radius = 10; }
	CALayer *layer = [CALayer layer];
	layer.backgroundColor = color.CGColor;
	layer.frame = CGRectMake( 0, 0, radius * 2, radius * 2 );
	
	UIGraphicsBeginImageContextWithOptions( CGSizeMake( radius * 2, radius * 2 ), YES, 2.0 );
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality( context, kCGInterpolationHigh );
	[layer renderInContext:context];
	layer.shouldRasterize = YES;
	UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return gradientImage;
}
+ (UIImage *) imageOfSize:(CGSize)mysize withGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
	return [UIImage imageOfSize:mysize withGradientFromColor:fromColor toColor:toColor colorStop1:0 colorStop2:1];
}
+ (UIImage *) imageOfSize:(CGSize)mysize withGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor colorStop1:(float)stop1 colorStop2:(float)stop2 {
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = CGRectMake( 0, 0, mysize.width, mysize.height );
	gradient.colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, (id)toColor.CGColor, nil];
	gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:stop1], [NSNumber numberWithFloat:stop2], nil];
	
	UIGraphicsBeginImageContextWithOptions( CGSizeMake( mysize.width, mysize.height ), YES, 2.0 );
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality( context, kCGInterpolationHigh );
	[gradient renderInContext:context];
	gradient.shouldRasterize = YES;
	UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return gradientImage;
}
+ (UIImage *) imageOfSize:(CGSize)mysize withGradientFromBaseColor:(UIColor *)fromColor {
	return [self imageOfSize:mysize withGradientFromColor:fromColor toColor:[fromColor colorDarkenedByPercent:0.2] colorStop1:0 colorStop2:1];
}
+ (UIImage *) imageOfSize:(CGSize)mysize withGradientFromBaseColor:(UIColor *)fromColor andCornerRadius:(int)radius andBorderWidth:(int)borderWidth {
	// bottom highlight
	CALayer *highlight = [CALayer layer];
	highlight.frame = CGRectMake( 0, 0, mysize.width, mysize.height );
	highlight.backgroundColor = [fromColor colorLightenedByPercent:0.5].CGColor;
	highlight.cornerRadius = radius;
	highlight.masksToBounds = YES;
	
	// base layer and border
	CALayer *baseLayer = [CALayer layer];
	baseLayer.frame = CGRectMake( 0, 0, mysize.width, mysize.height - 1 );
	baseLayer.cornerRadius = radius;
	baseLayer.masksToBounds = YES;
	baseLayer.borderColor = [fromColor colorDarkenedByPercent:0.4].CGColor;
	baseLayer.borderWidth = borderWidth;
	baseLayer.contents = (id)[UIImage imageOfSize:mysize withGradientFromBaseColor:fromColor].CGImage;
	[highlight addSublayer:baseLayer];
	
	UIGraphicsBeginImageContextWithOptions( CGSizeMake( mysize.width, mysize.height ), NO, 2.0 );
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality( context, kCGInterpolationHigh );
	[highlight renderInContext:context];
	highlight.shouldRasterize = YES;
	UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return gradientImage;
}
@end

@implementation UIAlertView (Creation)
+ (void) showAlertViewWithTitle:(NSString *)title andText:(NSString *)text {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:NSLocalizedString( @"OK", @"" ) otherButtonTitles:nil];
	[alert show];
}
+ (UIAlertView *)alertViewWithTitle:(NSString *)title andText:(NSString *)text andButtons:(NSArray *)buttons {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	alert.cancelButtonIndex = 0;
	for ( int i = 0; i < buttons.count; i++ ) {
		[alert addButtonWithTitle:[buttons objectAtIndex:i]];
	}
	return alert;
}
- (void) setCompletionBlock:(void (^)(NSUInteger buttonIndex, UIAlertView *alertView))block {
	objc_setAssociatedObject(self, "blockCallback", [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	self.delegate = self;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	void (^block)(NSUInteger buttonIndex, UIAlertView *alertView) = objc_getAssociatedObject(self, "blockCallback");
	if ( !block ) { return; }
	block(buttonIndex, self);
}
@end

@implementation UIActionSheet (Creation)
// NOTE : When using this method, a "cancel" button is added automatically
+ (UIActionSheet *) actionSheetWithTitle:(NSString *)title andButtons:(NSArray *)buttons {
	UIActionSheet *sheet = [[UIActionSheet alloc] init];
	if ( !IS_EMPTY_STRING( title ) ) { sheet.title = title; }
	for ( int i = 0; i < buttons.count; i++ ) {
		[sheet addButtonWithTitle:[buttons objectAtIndex:i]];
	}
	[sheet addButtonWithTitle:NSLocalizedString( @"Cancel", @"" )];
	sheet.cancelButtonIndex = [buttons count];
	return sheet;
}
- (void) setCompletionBlock:(void (^)(NSUInteger buttonIndex, UIActionSheet *actionSheet))block {
	objc_setAssociatedObject(self, "blockCallback", [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	self.delegate = self;
}
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ( buttonIndex == actionSheet.cancelButtonIndex ) { return; }
	void (^block)(NSUInteger buttonIndex, UIActionSheet *actionSheet) = objc_getAssociatedObject(self, "blockCallback");
	block(buttonIndex, self);
}
@end


@implementation UIBarButtonItem (Custom)

+ (UIBarButtonItem *) buttonWithImage:(NSString *)imageName andDisabledImage:(NSString *)disabledName andSelector:(SEL)myselector onTarget:(id)target {
	UIImage *defaultImage = [UIImage imageNamed:imageName];
	UIImage *disabledImage = [UIImage imageNamed:disabledName];
	return [self buttonWithUIImage:defaultImage andDisabledUIImage:disabledImage andSelector:myselector onTarget:target];
}

+ (UIBarButtonItem *) buttonWithUIImage:(UIImage *)defaultImage andDisabledUIImage:(UIImage *)disabledImage andSelector:(SEL)myselector onTarget:(id)target {
	UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:defaultImage forState:UIControlStateNormal];
	[button setImage:disabledImage forState:UIControlStateDisabled];
	[button addTarget:target action:myselector forControlEvents:UIControlEventTouchUpInside];
	[button setFrame:CGRectMake( 0, 0, defaultImage.size.width, defaultImage.size.height )];
	return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
