//
//  TweetCell.m
//  JoggSample
//
//  Created by Mike Johnson on 2/21/15.
//  Copyright (c) 2015 jogg. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell {
	TweetModel *mymodel;
	
	UILabel *userLabel;
	UILabel *timeLabel;
	UILabel *bodyLabel;
	UIImageView *userImage;
}

#pragma mark - Static Methods

+ (CGFloat) heightForText:(NSString *)mytext {
	int textHeight = [mytext heightOfTextForWidth:(SCREEN_SIZE_ORIENTED.width - 60 - 10) withFont:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT] andLineBreakMode:NSLineBreakByWordWrapping];
	textHeight += 30.0; // Account for the user label offsetting the vertical
	return MAX( 55.0, textHeight );
}

#pragma mark - Lifecycle Methods

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if ( self ) { [self createInterface]; }
	return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	userLabel.width = self.contentView.width - userLabel.left - 10;
	bodyLabel.width = self.contentView.width - bodyLabel.left - 10;
	timeLabel.right = self.contentView.width - 20;
	bodyLabel.height = self.contentView.height - bodyLabel.top - 5;
}

#pragma mark - Public Methods

- (void) setData:(TweetModel *)newData {
	mymodel = newData;
	
	userLabel.text = [NSString stringWithFormat:@"@%@", mymodel.userScreename];
	timeLabel.text = [mymodel.createdAtDate getRelativeTimeShortDescription];
	bodyLabel.text = mymodel.text;
	[userImage setImageFromURL:mymodel.userProfileImageUrl];
}

#pragma mark - Private Methods

- (void) createInterface {
	userImage = [[UIImageView alloc] init];
	userImage.frame = CGRectMake( 15, 5, 40, 40 );
	[userImage setCornerRadius:2 withBorderColor:COLOR_TITLE_BAR andBorderSize:1];
	[self.contentView addSubview:userImage];
	
	userLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT] andFrame:CGRectMake( userImage.right + 10, 5, 0, 15 ) andColor:COLOR_TEXT_BRIGHT];
	[self.contentView addSubview:userLabel];
	
	timeLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT] andFrame:CGRectMake( 0, 5, 100, 15 ) andColor:COLOR_TITLE_BAR];
	timeLabel.textAlignment = NSTextAlignmentRight;
	[self.contentView addSubview:timeLabel];
	
	bodyLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:FONT_SIZE_DEFAULT] andFrame:CGRectMake( userImage.right + 10, userLabel.bottom, 0, 35 ) andColor:COLOR_TEXT_DEFAULT];
	bodyLabel.numberOfLines = 0;
	bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
	[self.contentView addSubview:bodyLabel];
	
}

@end
