//
//  UIImageView+LoadURL.m
//
//  Created by Mike Johnson on 1/29/13.
//  Copyright (c) 2013 Exorcyze Studios. All rights reserved.
//


#import "UIImageView+LoadURL.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (LoadURL)

- (void) setImageFromURL:(NSString *)url {
	[self setImageFromURL:url withCompletionBlock:nil];
}

- (void) setImageFromURL:(NSString *)url withCompletionBlock:(void (^)(BOOL success))block {
	
	// src : http://stackoverflow.com/questions/933099/getting-image-from-url-objective-c
	dispatch_async(dispatch_get_global_queue(0,0), ^{
		NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
		//NSLog( @"Data Loaded, length : %i", data.length );
		if ( data == nil ) { return; }
		dispatch_async(dispatch_get_main_queue(), ^{
			[self setImage:[UIImage imageWithData:data]];
			if ( !block ) { return; }
			BOOL hasImage = data.length > 50;
			block( hasImage );
		});
	});
	
}

- (void) setImageFromURL:(NSString *)url withPlaceholderImage:(UIImage *)myimage withCompletionBlock:(void (^)(BOOL success))block {
	[self setImage:myimage];
	[self setImageFromURL:url withCompletionBlock:block];
}
- (void) setImageFromURL:(NSString *)url withPlaceholderImageNamed:(NSString *)imageName withCompletionBlock:(void (^)(BOOL success))block {
	[self setImage:[UIImage imageNamed:imageName]];
	[self setImageFromURL:url withCompletionBlock:block];
}

@end
