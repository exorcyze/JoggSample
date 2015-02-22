//
//  CacheHelper.h
//
//  Created by Mike Johnson on 10/13/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheHelper : NSObject

+ (void) cacheString:(NSString *)data forKey:(NSString *)key;
+ (NSString *) getCacheForKey:(NSString *)key;
+ (BOOL) hasCacheForKey:(NSString *)key;

@end
