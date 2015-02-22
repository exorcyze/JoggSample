//
//  NSObject+AssociatedObjects.m
//  Cliq
//
//  Created by Jason Blood on 2/14/13.
//  Copyright (c) 2013 Cliq Communications. All rights reserved.
//

#import "NSURLConnection+Blocks.h"

@implementation NSURLConnection (block)

#pragma mark API
+ (void)asyncRequest:(NSURLRequest *)request success:(void(^)(NSData *data, NSURLResponse *response, NSError *error))successBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        
		//NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		//long code = [httpResponse statusCode];
		//if ( code != 200 ) { NSLog( @"RESPONSE CODE : %li", code ); }
		
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //if ( code != 200 ) { NSLog( @"RESPONSE DATA : %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ); }
		
        if (successBlock != nil)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (error)
                {
                    successBlock(data, response, error);
                }
                else
                {
                    successBlock(data, response, nil);
                }
            });//end block
        }
    });
}

@end