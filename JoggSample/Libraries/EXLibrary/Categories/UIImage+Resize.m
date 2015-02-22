//
//  UIImage+Resize.m
//  cliq
//
//  Created by Mike Johnson on 2/20/14.
//  Copyright (c) 2014 cliq. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *) imageScaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 1.0 );
    [self drawInRect:CGRectMake( 0, 0, newSize.width, newSize.height )];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
