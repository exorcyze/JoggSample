//
//  SampleDataService.m
//  EXLibrary
//
//  Created by Mike Johnson on 1/26/13.
//  Copyright (c) 2013 Exorcyze Studios. All rights reserved.
//

#import "SampleDataService.h"

#import "STTwitter.h"
#import "TweetModel.h"

@interface BaseDataService (Private)
- (void) loadDataAsync:(NSString *)urlString withSelector:(SEL)callbackSel withError:(SEL)errorSel;
- (void) postDataAsync:(NSString *)urlString withData:(NSDictionary *)data withSelector:(SEL)callbackSel withError:(SEL)errorSel;
- (void) postImageAsync:(NSString *)urlString withData:(NSDictionary *)data image:(UIImage *)image withSelector:(SEL)callbackSel withError:(SEL)errorSel;
- (void) showNetworkIndicator;
- (void) hideNetworkIndicator;
@end


@interface SampleDataService ()
@end


@implementation SampleDataService {
	void (^blockTwitterSearch)(NSArray *returnData, NSError *returnError);
	void (^blockTwitterUserSearch)(NSArray *returnData, NSError *returnError);
}

#pragma mark - Public Methods

- (void) getTwitterResultsForTerm:(NSString *)searchTerm onComplete:(void (^)(NSArray *returnData, NSError *returnError))block {
	blockTwitterSearch = block;
	
	// this is horrible design on the part of this library
	STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_KEY consumerSecret:TWITTER_SECRET];
	[twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
		[twitter getSearchTweetsWithQuery:searchTerm successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
			//NSLog( @"%@", statuses[ 0 ] );
			NSMutableArray *ret = [NSMutableArray new];
			for ( int i = 0; i < statuses.count; i++ ) {
				NSDictionary *item = statuses[ i ];
				TweetModel *tweet = [TweetModel tweetModelFromDictionary:item];
				[ret addObject:tweet];
			}
			
			blockTwitterSearch( ret, nil );
		} errorBlock:^(NSError *error) {
			NSLog( @"%@", error.localizedDescription );
			blockTwitterSearch( nil, error );
		}];
	} errorBlock:^(NSError *error) {
		NSLog( @"%@", error.localizedDescription );
		blockTwitterSearch( nil, error );
	}];
}

#pragma mark - Private Methods

#pragma mark - Response Methods

@end
