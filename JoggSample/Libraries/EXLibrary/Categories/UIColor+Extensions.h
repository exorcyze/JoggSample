//
//  UIColor+Extensions.h
//
//  Created by Mike Johnson on 7/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (Extensions)

+ (UIColor *) colorFromHex:(UInt32)hex;
+ (UIColor *) colorFromHex:(UInt32)hex withAlpha:(float)alpha;
- (UIColor *) colorDarkenedByPercent:(float)percent;
- (UIColor *) colorLightenedByPercent:(float)percent;

@end
