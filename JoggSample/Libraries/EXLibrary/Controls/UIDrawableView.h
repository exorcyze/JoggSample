//
//  UIDrawableView.h
//

// Add ability to draw on a UIView without creating a separate class
// Source : http://www.davidhamrick.com/2011/08/07/using-blocks-for-drawing-to-avoid-subclasssing-in-objective-c.html
// Example usage :
/*
drawableView.drawBlock = ^( UIView *v, CGContextRef context ) {
	CGPoint startPoint = CGPointMake(0,v.bounds.size.height-1);
	CGPoint endPoint = CGPointMake(v.bounds.size.width,v.bounds.size.height-1);

	CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
	CGContextSetLineWidth(context, 1);
	CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
	CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
	CGContextStrokePath(context);
};
*/

#import <UIKit/UIKit.h>

typedef void(^UIDrawableView_DrawBlock)( UIView *v, CGContextRef context );

@interface UIDrawableView : UIView

@property (nonatomic,copy) UIDrawableView_DrawBlock drawBlock;

@end


