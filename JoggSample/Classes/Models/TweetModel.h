//
//  TweetModel.h
//  JoggSample
//
//  Created by Mike Johnson on 2/21/15.
//  Copyright (c) 2015 jogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetModel : NSObject

@property (nonatomic) long tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAtDate;
@property (nonatomic, strong) NSString *userScreename;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userProfileImageUrl;
@property (nonatomic, strong) NSString *userLocation;

/** Factory method for creating a tweet from a dictionary */
+ (instancetype) tweetModelFromDictionary:(NSDictionary *)data;

@end
