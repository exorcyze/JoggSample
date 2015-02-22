//
//  TweetCell.h
//  JoggSample
//
//  Created by Mike Johnson on 2/21/15.
//  Copyright (c) 2015 jogg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TweetModel.h"

@interface TweetCell : UITableViewCell

/** Used to calculate the size of the row for a given string */
+ (CGFloat) heightForText:(NSString *)mytext;

/** Sets the data to be displayed */
- (void) setData:(TweetModel *)newData;

@end
