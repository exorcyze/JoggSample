//
//  UIControl+Creation.h
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//
//  Intended to assist in the creation of controls by 
//  encapsulating some of the tedium. Also each sets the
//  anchor point to top left so positioning can be done 
//  by setting only the center point.

#import <UIKit/UIKit.h>

@interface UIControl_Creation : NSObject
@end

@interface UIView (Rounding)
- (void) setCornerRadius:(int)radius withBorderColor:(UIColor *)borderColor andBorderSize:(float)borderSize;
+ (UIView *) viewWithFrame:(CGRect)frame andBackgroundColor:(UIColor *)backgroundColor;
@end

@interface UIButton (Creation)
+ (UIButton *)buttonWithTitle:(NSString *)title andSelector:(SEL)myselector onTarget:(id)target;
+ (UIButton *)buttonWithImage:(NSString *)imageName andSelector:(SEL)myselector onTarget:(id)target;
+ (UIButton *)buttonWithImage:(NSString *)imageName disabledImage:(NSString *)disabledImageName andSelector:(SEL)myselector onTarget:(id)target;
+ (UIButton *)buttonWithTitle:(NSString *)title andBackgroundColor:(UIColor *)backgroundColor andColor:(UIColor *)textColor andCornerRadius:(int)corner;
+ (UIButton *) flatButtonWithTitle:(NSString *)title andBackgroundColor:(UIColor *)backgroundColor andColor:(UIColor *)textColor;
- (void) addActionBlock:(void (^)(UIButton *sender))block;
@end

@interface UILabel (Creation)
+ (UILabel *)labelWithFont:(UIFont *)font andFrame:(CGRect)frame andColor:(UIColor *)color;
+ (UILabel *)labelWithFont:(UIFont *)font andFrame:(CGRect)frame andColor:(UIColor *)color andShadow:(BOOL)shadow;
- (void) setShadowColor:(UIColor *)shadowColor withOffset:(CGSize)offset;
- (float) sizeWidthForContent; // autosize width to content and return that width
@end

@interface UITextField (Creation)
+ (UITextField *)textFieldWithFont:(UIFont *)font andFrame:(CGRect)frame andPlaceholder:(NSString *)placeholder;
@end

@interface UITextView (Creation)
+ (UITextView *) textViewWithFont:(UIFont *)font andFrame:(CGRect)frame;
@end

@interface UIImageView (Creation)
+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName;
@end

@interface UIImage (Creation)
+ (UIImage *) imageWithColor:(UIColor *)color andCornerRadius:(int)radius;
+ (UIImage *) imageOfSize:(CGSize)mysize withGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
+ (UIImage *) imageOfSize:(CGSize)mysize withGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor colorStop1:(float)stop1 colorStop2:(float)stop2;
+ (UIImage *) imageOfSize:(CGSize)mysize withGradientFromBaseColor:(UIColor *)fromColor;
+ (UIImage *) imageOfSize:(CGSize)mysize withGradientFromBaseColor:(UIColor *)fromColor andCornerRadius:(int)radius andBorderWidth:(int)borderWidth;
@end

@interface UIAlertView (Creation) <UIAlertViewDelegate>
+ (void) showAlertViewWithTitle:(NSString *)title andText:(NSString *)text;
+ (UIAlertView *)alertViewWithTitle:(NSString *)title andText:(NSString *)text andButtons:(NSArray *)buttons;
- (void) setCompletionBlock:(void (^)(NSUInteger buttonIndex, UIAlertView *alertView))block;
@end


@interface UIActionSheet (Creation) <UIActionSheetDelegate>
+ (UIActionSheet *) actionSheetWithTitle:(NSString *)title andButtons:(NSArray *)buttons;
- (void) setCompletionBlock:(void (^)(NSUInteger buttonIndex, UIActionSheet *actionSheet))block;
@end

@interface UIBarButtonItem (Custom)
+ (UIBarButtonItem *) buttonWithImage:(NSString *)imageName andDisabledImage:(NSString *)disabledName andSelector:(SEL)myselector onTarget:(id)target;
+ (UIBarButtonItem *) buttonWithUIImage:(UIImage *)defaultImage andDisabledUIImage:(UIImage *)disabledImage andSelector:(SEL)myselector onTarget:(id)target;
@end
