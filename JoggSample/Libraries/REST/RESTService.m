//
//  RESTService.m
//  mySharp
//
//  Created by Jason Blood on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RESTService.h"
#import "NSURLConnection+Blocks.h"
#import "NSString+Calculations.h"
#import "Session.h"
#import <AdSupport/AdSupport.h>
#import "CacheHelper.h"

@interface RESTService ()
- (NSString *) getAuthorizationHeader;
@end

@implementation RESTService

#pragma mark - Private Methods

- (NSString *) getAuthorizationHeader {
	NSString *uname = [CURRENT_USERNAME stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
	NSString *rawAuth = [[[NSString stringWithFormat:@"%@:%@", uname, CURRENT_PASSWORD] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
	rawAuth = [rawAuth stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
	//NSLog( @"UNAME : %@", uname );
	//NSLog( @"AUTH : \n%@", rawAuth );
	//return [NSString base64String:rawAuth];
	return [NSString stringWithFormat: @"Basic %@", rawAuth];
}

- (NSString *) getNewAuthorizationHeader {
	NSString *clientKey = @"CLIENT_KEY";
	NSString *uname = CURRENT_USERNAME;
	NSString *pass = CURRENT_PASSWORD;
	long TWO_WEEKS = 604800;
	NSTimeInterval unixTimestamp = [[[NSDate date] dateByAddingTimeInterval:TWO_WEEKS] timeIntervalSince1970];
	NSString *sha1 = [[NSString alloc] initWithData:[pass sha1] encoding:NSUTF8StringEncoding];
	NSString *authString = [NSString stringWithFormat:@"%@:%@:%@:%qu", clientKey, uname, sha1, ((long long)unixTimestamp)];
	return  [[authString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

#pragma mark - Public Methods
- (instancetype) init {
	self = [super init];
	if ( self ) { self.isPreloadResult = NO; }
	return self;
}

- (void) getUrl:(NSString *)urlString onCompletion:(void (^)(id obj, NSError *error))completion {
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setURL:[NSURL URLWithString:urlString]];
    [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [theRequest setTimeoutInterval:60.0];
	
    [theRequest setValue:[self getAuthorizationHeader] forHTTPHeaderField:@"Authorization"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
	if ( !IS_EMPTY_STRING( self.cacheKey ) && [CacheHelper hasCacheForKey:self.cacheKey] ) {
		NSString *cache = [CacheHelper getCacheForKey:self.cacheKey];
		id data = [NSJSONSerialization JSONObjectWithData:[cache dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
		self.isPreloadResult = YES;
		completion( data, nil );
	}
	
    [NSURLConnection asyncRequest:theRequest success:^(NSData *data, NSURLResponse *response, NSError *error) {
		self.isPreloadResult = NO;
		if ( completion ==  nil ) { return; }
		if ( data == nil ) {
			NSLog( @"ERROR : %@", error.localizedDescription );
			completion( nil, error );
			return;
		}
		if ( data.length == 0 ) {
			NSLog( @"ERROR : %@", error.localizedDescription );
			completion( nil, error );
			return;
		}
		
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		long code = [httpResponse statusCode];
		if ( code != 200 ) { NSLog( @"RESPONSE CODE : %li", code ); }
		
		id dta = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		if ( [dta isKindOfClass:[NSDictionary class]] ) {
			if ( [(NSDictionary *)dta objectForKey:@"error"] ) {
				error = [NSError errorWithDomain:SERVICE_URL code:9999 userInfo:@{NSLocalizedDescriptionKey: [(NSDictionary *)dta objectForKey:@"error"] } ];
				NSLog( @"ERROR DURING GET : %@", error.localizedDescription );
			}
		}
		
		if ( !IS_EMPTY_STRING( self.cacheKey ) && !error ) {
			NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			[CacheHelper cacheString:responseString forKey:self.cacheKey];
		}
		completion(dta, error);
		
    }];
}
- (void)putUrl:(NSString *)urlString withObject:(id)data onCompletion:(void (^)(id obj, NSError *error))completion
{
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setURL:[NSURL URLWithString:urlString]];
    [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [theRequest setTimeoutInterval:60.0];
	[theRequest setHTTPMethod:@"PUT"];
    
    [theRequest setValue:[self getAuthorizationHeader] forHTTPHeaderField:@"Authorization"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:requestData];
    
    [NSURLConnection asyncRequest:theRequest success:^(NSData *data, NSURLResponse *response, NSError *error) {
		self.isPreloadResult = NO;
		if ( completion ==  nil ) { return; }
		if ( data == nil ) {
			NSLog( @"ERROR : %@", error.localizedDescription );
			completion( nil, error );
			return;
		}
		if ( data.length == 0 ) {
			NSLog( @"ERROR : %@", error.localizedDescription );
			completion( nil, error );
			return;
		}
		
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		long code = [httpResponse statusCode];
		if ( code != 200 ) { NSLog( @"RESPONSE CODE : %li", code ); }
		
		id dta = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		if ( [dta isKindOfClass:[NSDictionary class]] ) {
			if ( [(NSDictionary *)dta objectForKey:@"error"] ) {
				error = [NSError errorWithDomain:SERVICE_URL code:9999 userInfo:@{NSLocalizedDescriptionKey: [(NSDictionary *)dta objectForKey:@"error"] } ];
				NSLog( @"ERROR DURING PUT : %@", error.localizedDescription );
			}
		}
		
		if ( !IS_EMPTY_STRING( self.cacheKey ) ) {
			NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			[CacheHelper cacheString:responseString forKey:self.cacheKey];
		}
		
		completion(dta, error);
    }];
}

- (void)deleteUrl:(NSString *)urlString onCompletion:(void (^)(id obj, NSError *error))completion {
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setValue:[self getAuthorizationHeader] forHTTPHeaderField:@"Authorization"];
    [theRequest setURL:[NSURL URLWithString:urlString]];
    [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [theRequest setTimeoutInterval:60.0];
	[theRequest setHTTPMethod:@"DELETE"];
    
    //these are needed for .NET service calls to return JSON
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection asyncRequest:theRequest success:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completion != nil)
        {
            if (data == nil)
            {
                completion(nil, error);
            }
            else
            {
                if ([data length] == 0)
                {
                    completion(nil, error);
                }
                else
                {
                    id dta = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
					if ( [dta isKindOfClass:[NSDictionary class]] ) {
						if ( [(NSDictionary *)dta objectForKey:@"error"] ) {
							error = [NSError errorWithDomain:SERVICE_URL code:9999 userInfo:@{NSLocalizedDescriptionKey: [(NSDictionary *)dta objectForKey:@"error"] } ];
						}
					}
                    completion(dta, error);
                }
            }
        }
    }];
}
- (void)postUrl:(NSString *)urlString withObject:(id)data onCompletion:(void (^)(id obj, NSError *error))completion {
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    [theRequest setValue:[self getAuthorizationHeader] forHTTPHeaderField:@"Authorization"];
    [theRequest setURL:[NSURL URLWithString:urlString]];
    [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [theRequest setTimeoutInterval:60.0];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:requestData];
    
	//NSLog( @"UNAME : %@, PWORD : %@", SESSION.currentUsername, SESSION.currentPassword );
	//NSLog( @"AUTH : %@", [self getAuthorizationHeader] );
	//NSLog( @"POSTING : %@", requestData );
	
    [NSURLConnection asyncRequest:theRequest success:^(NSData *data, NSURLResponse *response, NSError *error) {
		if ( completion ==  nil ) { return; }
		if ( data == nil ) {
			NSLog( @"NO DATA" );
			completion( nil, error );
			return;
		}
		if ( data.length == 0 ) {
			NSLog( @"NO DATA" );
			completion( nil, error );
			return;
		}
		
		id dta = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		//NSLog( @"DTA : %@", dta );
		//NSLog( @"ERROR : %@", error.localizedDescription );
		if ( [dta isKindOfClass:[NSDictionary class]] ) {
			if ( [(NSDictionary *)dta objectForKey:@"error"] ) {
				NSLog( @"DATA ERROR : %@", dta );
				error = [NSError errorWithDomain:SERVICE_URL code:9999 userInfo:@{NSLocalizedDescriptionKey: [(NSDictionary *)dta objectForKey:@"error"] } ];
			}
		}
		completion(dta, error);
    }];
}

- (void)postUrl:(NSString *)urlString withObject:(id)data andImage:(UIImage *)image onCompletion:(void (^)(id obj, NSError *error))completion
{
    NSString *stringBoundary = @"0xGiRnDyDbStSbR---aub";
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
	NSData *imageData = UIImageJPEGRepresentation( image, 0.8 );
	
	NSMutableData *postBody = [self dataFromDictionary:data stringBoundary:stringBoundary image:imageData];
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: postBody];
    [request setTimeoutInterval:90];
	
	[NSURLConnection asyncRequest:request success:^(NSData *data, NSURLResponse *response, NSError *error) {
		//NSLog( @"ERROR %lu : %@", error.code, error.localizedDescription );
		//NSLog( @"DATA : %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
		//NSLog( @"RESPONSE : %@", response.debugDescription );
		//NSInteger mystatus = [(NSHTTPURLResponse *)response statusCode];
		//NSLog( @"RESPONSE CODE : %lu", mystatus );
		
		if ( completion ==  nil ) { return; }
		if ( data == nil ) {
			//NSLog( @"NO DATA" );
			completion( nil, error );
			return;
		}
		if ( data.length == 0 ) {
			//NSLog( @"NO DATA" );
			completion( nil, error );
			return;
		}
		
		id dta = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		if ( [dta isKindOfClass:[NSDictionary class]] ) {
			if ( [(NSDictionary *)dta objectForKey:@"error"] ) {
				//NSLog( @"DATA ERROR : %@", dta );
				error = [NSError errorWithDomain:SERVICE_URL code:9999 userInfo:@{NSLocalizedDescriptionKey: [(NSDictionary *)dta objectForKey:@"error"] } ];
			}
		}
		completion(dta, error);
	}];
	
}

- (NSMutableData*) dataFromDictionary:(NSDictionary*)parameterDictionary stringBoundary:(NSString*)stringBoundary image:(NSData*)imageData {
    
    NSMutableData* postBody = [NSMutableData data];
    
    // form
    for (NSString* aKey in parameterDictionary) {
		id myval = [parameterDictionary valueForKey:aKey];
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", aKey] dataUsingEncoding:NSUTF8StringEncoding]];
		if ( [myval isKindOfClass:[NSString class]] ) {
			[postBody appendData:[myval dataUsingEncoding:NSUTF8StringEncoding]];
		}
		else if ( CFNumberGetType( (CFNumberRef)myval ) == kCFNumberSInt32Type || CFNumberGetType( (CFNumberRef)myval ) == kCFNumberIntType ) {
			NSString *val = [NSString stringWithFormat:@"%i", [myval intValue]];
			[postBody appendData:[val dataUsingEncoding:NSUTF8StringEncoding]];
		}
		else {
			NSString *val = [NSString stringWithFormat:@"%lu", [myval longValue]];
			[postBody appendData:[val dataUsingEncoding:NSUTF8StringEncoding]];
		}
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // media part
    
    if ([imageData length] > 0)
    {
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"snap.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: image/png\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:imageData];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return postBody;
    
}

@end