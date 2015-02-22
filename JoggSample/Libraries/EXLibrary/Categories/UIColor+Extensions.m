//
//  UIColor+Extensions.m
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "UIColor+Extensions.h"


@implementation UIColor (Extensions)

+ (UIColor *) colorFromHex:(UInt32) hex {
	return [UIColor colorFromHex:hex withAlpha:1.0];
}
+ (UIColor *) colorFromHex:(UInt32)hex withAlpha:(float)alpha {
	return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}

- (UIColor *) colorLightenedByPercent:(float)percent {
	CGFloat r = 0, g = 0, b = 0, a = 0;
	if ( ![self respondsToSelector:@selector(getRed:green:blue:alpha:)] ) { return self; } // return same color if < iOS 5
	[self getRed:&r green:&g blue:&b alpha:&a];
	r = r * percent + r;
	g = g * percent + g;
	b = b * percent + b;
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
- (UIColor *) colorDarkenedByPercent:(float)percent {
	CGFloat r = 0, g = 0, b = 0, a = 0;
	if ( ![self respondsToSelector:@selector(getRed:green:blue:alpha:)] ) { return self; } // return same color if < iOS 5
	[self getRed:&r green:&g blue:&b alpha:&a];
	r = r - r * percent;
	g = g - g * percent;
	b = b - b * percent;
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
