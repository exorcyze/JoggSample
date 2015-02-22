//
//  NSObject+AssociatedObjects.h
//  Cliq
//
//  Created by Jason Blood on 2/14/13.
//  Copyright (c) 2013 Cliq Communications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection (block)

+ (void)asyncRequest:(NSURLRequest *)request success:(void(^)(NSData *data, NSURLResponse *response, NSError *error))successBlock;

@end