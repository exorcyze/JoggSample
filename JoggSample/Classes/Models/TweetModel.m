//
//  TweetModel.m
//  JoggSample
//
//  Created by Mike Johnson on 2/21/15.
//  Copyright (c) 2015 jogg. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel

#pragma mark - Static Methods

+ (instancetype) tweetModelFromDictionary:(NSDictionary *)data {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	format.dateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
	
	TweetModel *ret = [TweetModel new];
	ret.tweetId = SAFE_INT_VALUE( data[ @"id" ] );
	ret.text = data[ @"text" ];
	ret.createdAtDate = [format dateFromString:data[ @"created_at" ] ];
	
	NSDictionary *user = data[ @"user" ];
	ret.userName = user[ @"name" ];
	ret.userScreename = user[ @"screen_name" ];
	ret.userProfileImageUrl = user[ @"profile_image_url" ];
	ret.userLocation = user[ @"location" ];
	
	return ret;
}

@end

