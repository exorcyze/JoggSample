//
//  DataService.h
//
//  Created by Mike Johnson on 10/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "AppDelegate.h"


// DEVELOPMENT

//#define SECURE_WEB_SERVICE_URL @"https://localhost/sayfiereview/api/v1/"
//#define WEB_SERVICE_URL @"http://localhost/sayfiereview/api/v1/"

// PRODUCTION

#define SECURE_WEB_SERVICE_URL @"https://api.sayfiereview.com/v1/"
#define WEB_SERVICE_URL @"http://api.sayfiereview.com/v1/"



#define kDomain @"mydomain"
#define kTimeout 10
#define kTimeoutLong 30

#define ERROR_MESSAGE_PROVIDER @"An error happened - we're working on it!"
#define ERROR_PROVIDER 901

#define TWO_WEEKS 604800
#define ONE_DAY 43200

@interface BaseDataService : NSObject {
	NSObject *callbackObject;
	SEL callbackSelector;
	SEL callbackError;
	SEL parseSelector;
	SEL parseError;
	
	NSString *requestUrl;
	UIImage *postImage;
	NSString *postFileName;
	NSDictionary *postData;
	NSString *requestMethod; // used for caching
}

@property (nonatomic) BOOL cacheForPreload;
@property (nonatomic) BOOL isPreloadResult;
@property (nonatomic) double preloadCacheInterval;
@property (nonatomic) BOOL dumpCache;
@property (nonatomic, strong) NSString *requestMethod;

- (id) init;
- (void) cacheResponseWithInterval:(double)interval;
- (void) cancelRequest;

@end
