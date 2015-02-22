//
//  NSString+URLEncoding.m
//  mySharp
//
//  Created by Jason Blood on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncodingAdditions)

- (NSString *)URLEncodedString 
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}
@end
