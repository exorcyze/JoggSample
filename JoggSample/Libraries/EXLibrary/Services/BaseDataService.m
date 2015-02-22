//
//  DataService.m
//
//  Created by Mike Johnson on 10/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "BaseDataService.h"
#import "NSData+Helper.h"


@interface BaseDataService (Private)
- (void) loadDataAsync:(NSString *)urlString withSelector:(SEL)callbackSel withError:(SEL)errorSel;
- (void) postDataAsync:(NSString *)urlString withData:(NSDictionary *)data withSelector:(SEL)callbackSel withError:(SEL)errorSel;
- (void) postImageAsync:(NSString *)urlString withData:(NSDictionary *)data image:(UIImage *)image withSelector:(SEL)callbackSel withError:(SEL)errorSel;
- (void) putDataAsync:(NSURLRequest *)request withSelector:(SEL)callbackSel withError:(SEL)errorSel;
- (void) genericParse:(NSDictionary *)mydata;
- (void) genericError:(NSError *)error;
- (void) showNetworkIndicator;
- (void) hideNetworkIndicator;
@end

@implementation BaseDataService {
	NSMutableData *responseData;
	NSURLConnection *myconnection;
	long responseStatusCode;
	double myinterval;
	double myCacheInterval;
	BOOL cacheForInterval;
}

@synthesize cacheForPreload;
@synthesize preloadCacheInterval;
@synthesize dumpCache;
@synthesize requestMethod;

static int networkActivityCounter = 0;

#pragma mark - Lifecycle Methods

- (id) init {
	self = [super init];
	if ( self ) {
	}
	return self;
}


#pragma mark - Public Methods

- (void) cacheResponseWithInterval:(double)interval {
	myCacheInterval = interval;
	cacheForInterval = YES;
}

- (void) cancelRequest {
	[self hideNetworkIndicator];
	
	if ( myconnection != nil ) {
		NSLog( @"CANCEL : %@", [requestUrl substringFromIndex:WEB_SERVICE_URL.length] );
		//[TestFlight passCheckpoint:[NSString stringWithFormat:@"CANCEL : %@", [requestUrl substringFromIndex:WEB_SERVICE_URL.length] ] ];
		[myconnection cancel];
	}
}

#pragma mark - Load Methods

- (void)putDataAsync:(NSURLRequest *)request withSelector:(SEL)callbackSel withError:(SEL)errorSel {
	[self cancelRequest];
	
	parseSelector = callbackSel;
	parseError = errorSel;
	
	responseData = [NSMutableData data];
	myconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];	
}

- (void) loadDataAsync:(NSString *)urlString withSelector:(SEL)callbackSel withError:(SEL)errorSel {
	[self cancelRequest];
	[self showNetworkIndicator];
	
	parseSelector = callbackSel;
	parseError = errorSel;
	requestUrl = urlString;
	myinterval = [NSDate timeIntervalSinceReferenceDate];
	NSLog( @"LOAD : %@", requestUrl );
	//[TestFlight passCheckpoint:[NSString stringWithFormat:@"LOAD : %@", [requestUrl substringFromIndex:WEB_SERVICE_URL.length] ];
	
	if ( cacheForPreload && !IS_EMPTY_STRING( requestMethod ) ) {
		NSLog(@"CACHE FOR PRELOAD %@", requestMethod );
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", requestMethod] ];
		NSString *prefetch = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
		if ( !IS_EMPTY_STRING( prefetch ) ) {
			//NSLog( @"PREFETCH RESULTS FOR %@ : %@", requestMethod, prefetch );
			NSLog( @"PREFETCH AVAILABLE FOR %@", requestMethod );
			self.isPreloadResult = YES;
			NSError *error;
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[prefetch dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
			((void(*)(id, SEL, id))objc_msgSend)(self, parseSelector, json);
		}
		else {
			NSLog( @"NO PREFETCH FOR %@", requestMethod );
		}
	}
	
	if ( cacheForInterval && !IS_EMPTY_STRING( requestMethod ) ) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *datePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@:interval", requestMethod] ];
		NSString *dateCache = [NSString stringWithContentsOfFile:datePath encoding:NSUTF8StringEncoding error:NULL];
		NSTimeInterval ti = [[[NSDate date] dateByAddingTimeInterval:myCacheInterval] timeIntervalSince1970];
		NSTimeInterval expires = [dateCache doubleValue];
		//NSLog( @"CACHE : %f / %f", ti, expires );
		if ( ti < expires ) {
			NSLog(@"CACHE FOR PRELOAD %@", requestMethod );
			NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", requestMethod] ];
			NSString *prefetch = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
			if ( !IS_EMPTY_STRING( prefetch ) ) {
				//NSLog( @"PREFETCH RESULTS FOR %@ : %@", requestMethod, prefetch );
				NSLog( @"PREFETCH AVAILABLE FOR %@", requestMethod );
				NSError *error;
				NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[prefetch dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
				((void(*)(id, SEL, id))objc_msgSend)(self, parseSelector, json);
			}
			else {
				NSLog( @"NO PREFETCH FOR %@", requestMethod );
			}
		}
	}
	
	responseData = [NSMutableData data];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTimeout];
	//[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	//[request setHTTPMethod:@"GET"];
	myconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

- (void) postDataAsync:(NSString *)urlString withData:(NSDictionary *)data withSelector:(SEL)callbackSel withError:(SEL)errorSel {
	[self cancelRequest];
	[self showNetworkIndicator];
	
	parseSelector = callbackSel;
	parseError = errorSel;
	requestUrl = urlString;
	postData = data;
	myinterval = [NSDate timeIntervalSinceReferenceDate];
	//NSLog( @"POST : %@", requestUrl );
	//NSLog( @"POST DATA : %@", data );
	//NSLog( @"POST : %@", [requestUrl substringFromIndex:WEB_SERVICE_URL.length] );
	//[TestFlight passCheckpoint:[NSString stringWithFormat:@"POST : %@ ( Auth %@ )", [requestUrl substringFromIndex:WEB_SERVICE_URL.length], APP_DELEGATE.userEmail ] ];
	
	//NSError *error;
	//NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
	
	if ( cacheForPreload && !IS_EMPTY_STRING( requestMethod ) ) {
		NSLog(@"CACHE FOR PRELOAD %@", requestMethod );
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", requestMethod] ];
		NSString *prefetch = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
		if ( !IS_EMPTY_STRING( prefetch ) ) {
			//NSLog( @"PREFETCH RESULTS FOR %@ : %@", requestMethod, prefetch );
			NSLog( @"PREFETCH AVAILABLE FOR %@", requestMethod );
			self.isPreloadResult = YES;
			NSError *error;
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[prefetch dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
			//objc_msgSend( self, parseSelector, json );
			((void(*)(id, SEL, id))objc_msgSend)(self, parseSelector, json);
		}
		else {
			NSLog( @"NO PREFETCH FOR %@", requestMethod );
		}
	}
	
	//NSLog(@"CONNECTION STARTED");
	responseData = [NSMutableData data];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTimeoutLong];
	//[request addValue:@"1" forHTTPHeaderField:@"x-test-origin"];
	NSMutableString *postString = [[NSMutableString alloc] init];
	for ( NSString *key in data ) {
		[postString appendString:[NSString stringWithFormat:@"&%@=%@", key, [data objectForKey:key]]];
	}
	[request setHTTPBody:[[postString substringFromIndex:1] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPMethod:@"POST"];
	myconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) postImageAsync:(NSString *)urlString withData:(NSDictionary *)data image:(UIImage *)image withSelector:(SEL)callbackSel withError:(SEL)errorSel {
	[self cancelRequest];
	[self showNetworkIndicator];
	
	parseSelector = callbackSel;
	parseError = errorSel;
	requestUrl = urlString;
	postData = data;
	postImage = image;
	myinterval = [NSDate timeIntervalSinceReferenceDate];
	//NSLog( @"POST : %@", requestUrl );
	
	//NSError *error;
	//NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
	
	NSData *imageData = UIImageJPEGRepresentation( image, 90 );
	NSString *boundary = @"---------------------------9849436581144108930470211272";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	NSString *source = [data valueForKey:@"image_type"]; // @"app";
	
	//NSLog( @"POST IMAGE : %@ ( Type %@ )", [requestUrl substringFromIndex:WEB_SERVICE_URL.length], source );
	//[TestFlight passCheckpoint:[NSString stringWithFormat:@"POST IMAGE : %@ ( Type %@ )", [requestUrl substringFromIndex:WEB_SERVICE_URL.length], source ] ];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"image_type\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:source] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"upload\"; filename=\"my-image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	//[body appendData:[NSData dataWithData:jsonData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	responseData = [NSMutableData data];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTimeoutLong];
	//[request addValue:@"1" forHTTPHeaderField:@"x-test-origin"];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	//[request setValue:@"9117" forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPBody:body];
	[request setHTTPMethod:@"POST"];
	myconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnection Response Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//NSLog(@"CONNECTION RECEIVED RESPONSE");
	[responseData setLength:0];
	responseStatusCode = [(NSHTTPURLResponse *)response statusCode];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//NSLog(@"CONNECTION RECEIVED DATA");
	[responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//NSLog(@"CONNECTION FAILED WITH ERROR");
	[self hideNetworkIndicator];
	
	NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
	NSDictionary *myinfo = [NSDictionary dictionaryWithDictionary:info];
	
	NSError *myerror = [[NSError alloc] initWithDomain:kDomain code:0 userInfo:myinfo];
	((void(*)(id, SEL, id))objc_msgSend)(self, parseError, myerror);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self hideNetworkIndicator];
	
	//NSLog(@"LOADED %@ IN %f", [requestUrl substringFromIndex:WEB_SERVICE_URL.length], [NSDate timeIntervalSinceReferenceDate] - myinterval);
	//[TestFlight passCheckpoint:[NSString stringWithFormat:@"LOADED %@ IN %f", [requestUrl substringFromIndex:WEB_SERVICE_URL.length], [NSDate timeIntervalSinceReferenceDate] - myinterval] ];
	
	self.isPreloadResult = NO;
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	//NSLog(@"RESPONSE STRING: %@", responseString);
	NSError *error;
	NSDictionary *info;
	
	if ( responseData == nil ) {
		//NSLog( @"EMPTY RESPONSE DATA" );
		//[TestFlight passCheckpoint:@"Data Service - Empty Response Data" ];
		info = [NSDictionary dictionaryWithObjectsAndKeys:ERROR_MESSAGE_PROVIDER ,NSLocalizedDescriptionKey,nil];
		error = [[NSError alloc] initWithDomain:kDomain code:ERROR_PROVIDER userInfo:info];
		((void(*)(id, SEL, id))objc_msgSend)(self, parseError, error);
		return;
	} 
	
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
	if ( error ) {
		//[TestFlight passCheckpoint:[NSString stringWithFormat:@"DATA SERVICE - JSON PARSE ERROR: %@", responseString]];
		//NSLog( @"JSON PARSE ERROR : %@", error.localizedDescription );
		//[TestFlight passCheckpoint:[NSString stringWithFormat:@"JSON PARSE ERROR : %@", error.localizedDescription] ];
		info = [NSDictionary dictionaryWithObjectsAndKeys:ERROR_MESSAGE_PROVIDER ,NSLocalizedDescriptionKey,nil];
		error = [[NSError alloc] initWithDomain:kDomain code:ERROR_PROVIDER userInfo:info];
		((void(*)(id, SEL, id))objc_msgSend)(self, parseError, error);
		return;
	}
	
	BOOL success = ( responseStatusCode == 200 || responseStatusCode == 0 );
	if ( !success ) {
		//[TestFlight passCheckpoint:[NSString stringWithFormat:@"DATA SERVICE - ERROR CODE: %@", responseString]];
		NSString *errorMessage = NSLocalizedString( @"An error has occurred", @"generic data error" );
		if ( ![[(NSDictionary *)json valueForKey:@"message"] isEqual:[NSNull null]] ) { errorMessage = (NSString *)[(NSDictionary *)json valueForKey:@"message"]; }
		//NSLog( @"RESPONSE ERROR CODE : %i, %@", responseStatusCode, errorMessage );
		//NSLog( @"RAW : %@", responseString );
		//[TestFlight passCheckpoint:[NSString stringWithFormat:@"RESPONSE ERROR CODE : %i, %@", responseStatusCode, errorMessage] ];
		info = [NSDictionary dictionaryWithObjectsAndKeys:ERROR_MESSAGE_PROVIDER ,NSLocalizedDescriptionKey,nil];
		error = [[NSError alloc] initWithDomain:kDomain code:ERROR_PROVIDER userInfo:info]; 
		((void(*)(id, SEL, id))objc_msgSend)(self, parseError, error);
		return;
	}
	
	if( [responseString rangeOfString:@"server unavailable"].location != NSNotFound ) {
		//[TestFlight passCheckpoint:[NSString stringWithFormat:@"DATA SERVICE - SERVER UNAVAILABLE: %@", responseString]];
		//NSLog( @"SERVER UNAVAILABLE" );
		//[TestFlight passCheckpoint:@"Data Service - Server Unavailable" ];
		info = [NSDictionary dictionaryWithObjectsAndKeys:ERROR_MESSAGE_PROVIDER ,NSLocalizedDescriptionKey,nil];
		error = [[NSError alloc] initWithDomain:kDomain code:ERROR_PROVIDER userInfo:info]; 
		((void(*)(id, SEL, id))objc_msgSend)(self, parseError, error);
		return;
	}
	
	if ( [json isKindOfClass:[NSDictionary class]] ) {
		if ( !IS_EMPTY_STRING( [json objectForKey:@"status"] ) ) {
			if( [[json objectForKey:@"status"] isEqualToString:@"error"] ) {
				//[TestFlight passCheckpoint:[NSString stringWithFormat:@"DATA SERVICE - SERVICE ERROR NO OBJECT: %@", responseString]];
				//NSLog( @"SERVICE ERROR" );
				//[TestFlight passCheckpoint:@"Data Service - Service Error" ];
				info = [NSDictionary dictionaryWithObjectsAndKeys:ERROR_MESSAGE_PROVIDER ,NSLocalizedDescriptionKey,nil];
				error = [[NSError alloc] initWithDomain:kDomain code:ERROR_PROVIDER userInfo:info]; 
				((void(*)(id, SEL, id))objc_msgSend)(self, parseError, error);
				return;
			}
			if ( ![[json objectForKey:@"status"] isEqualToString:@"success"] ) {
				//[TestFlight passCheckpoint:[NSString stringWithFormat:@"DATA SERVICE - SERVICE ERROR NO OBJECT: %@", responseString]];
				//NSLog( @"SERVICE ERROR" );
				//[TestFlight passCheckpoint:@"Data Service - Service Error" ];
				NSString *mymessage = [[[json objectForKey:@"data"] objectAtIndex:0] objectForKey:@"message"];
				info = [NSDictionary dictionaryWithObjectsAndKeys:mymessage ,NSLocalizedDescriptionKey,nil];
				error = [[NSError alloc] initWithDomain:kDomain code:ERROR_PROVIDER userInfo:info];
				((void(*)(id, SEL, id))objc_msgSend)(self, parseError, error);
				return;
			}
		}
		
		if( [json objectForKey:@"error"] != nil ) {
			//[TestFlight passCheckpoint:[NSString stringWithFormat:@"DATA SERVICE - SERVICE ERROR: %@", responseString]];
			info = [NSDictionary dictionaryWithObjectsAndKeys:ERROR_MESSAGE_PROVIDER ,NSLocalizedDescriptionKey,nil];
			error = [[NSError alloc] initWithDomain:kDomain code:ERROR_PROVIDER userInfo:info]; 
			((void(*)(id, SEL, id))objc_msgSend)(self, parseError, error);
			return;
		}
	}
	
	if ( cacheForPreload && !IS_EMPTY_STRING( requestMethod ) ) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", requestMethod] ];
		[responseString writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
		//NSLog( @"SAVING PREFETCH FOR %@ : %@", requestMethod, responseString );
		//NSLog( @"SAVING PREFETCH FOR %@", requestMethod );
	}
	
	if ( cacheForInterval && !IS_EMPTY_STRING( requestMethod ) ) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *datePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@:interval", requestMethod] ];
		NSTimeInterval ti = [[[NSDate date] dateByAddingTimeInterval:myCacheInterval] timeIntervalSince1970];
		NSString *expireString = [NSString stringWithFormat:@"%f", ti];
		[expireString writeToFile:datePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", requestMethod] ];
		[responseString writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
		//NSLog( @"SAVING PREFETCH FOR %@", requestMethod );
	}
	
	// used instead of [self performSelector:withObject:] due to ARC compiler warnings : 
	// http://stackoverflow.com/questions/7043999/im-writing-a-button-class-in-objective-c-with-arc-how-do-i-prevent-clangs-m
	//objc_msgSend( self, parseSelector, json );
	((void(*)(id, SEL, id))objc_msgSend)(self, parseSelector, json);
}

#pragma mark - Generic Methods

- (void) genericParse:(NSDictionary *)data {
	//NSLog(@"DATA: %@", data);
	[callbackObject performSelectorOnMainThread:callbackSelector withObject:data waitUntilDone:YES];
}

- (void)genericError:(NSError *)error {
	//NSLog(@"METHOD %@ ERROR: %@", requestMethod, error);
	[callbackObject performSelectorOnMainThread:callbackError withObject:error waitUntilDone:YES];
}

#pragma mark - Network Activity Indicator Methods

- (void) showNetworkIndicator {
	networkActivityCounter++;
	UIApplication *app = [UIApplication sharedApplication];  
    [app setNetworkActivityIndicatorVisible:YES];
}

- (void) hideNetworkIndicator {
	networkActivityCounter--;
	if ( networkActivityCounter < 0 ) { networkActivityCounter = 0; }
	if ( networkActivityCounter > 0 ) { return; }
	UIApplication *app = [UIApplication sharedApplication];  
    [app setNetworkActivityIndicatorVisible:NO];
}

@end