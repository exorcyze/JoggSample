//
//  UIDrawableView.m
//

#import "UIDrawableView.h"

@implementation UIDrawableView

@synthesize drawBlock;

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ( self.drawBlock ) { self.drawBlock( self, context ); }
}


@end
