//
//  UIImageView+LoadURL.h
//
//  Created by Mike Johnson on 1/29/13.
//  Copyright (c) 2013 Exorcyze Studios. All rights reserved.
//
//  Quick way to load image from URL - not as robust as something like SDWebImage, but works for quick + dirty

#import <Foundation/Foundation.h>

@interface UIImageView (LoadURL)

- (void) setImageFromURL:(NSString *)url;
- (void) setImageFromURL:(NSString *)url withCompletionBlock:(void (^)(BOOL success))block;
- (void) setImageFromURL:(NSString *)url withPlaceholderImage:(UIImage *)myimage withCompletionBlock:(void (^)(BOOL success))block;
- (void) setImageFromURL:(NSString *)url withPlaceholderImageNamed:(NSString *)imageName withCompletionBlock:(void (^)(BOOL success))block;

@end
