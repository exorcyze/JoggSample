//
//  EXAlertView.h
//
//  Created by Mike Johnson on 1/29/13.
//  Copyright (c) 2013 Exorcyze Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR_BACKGROUND [UIColor colorFromHex:0x4a4a5b]
#define COLOR_BORDER [UIColor colorFromHex:0xffffff]
#define COLOR_BUTTON [UIColor colorFromHex:0x3a3a4b]
#define COLOR_TEXT [UIColor colorFromHex:0xffffff]

@interface EXAlertView : UIView

+ (EXAlertView *) alertViewWithTitle:(NSString *)newTitle andMessage:(NSString *)newMessage;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

- (void) setButtonTitles:(NSArray *)newTitles;
- (void) showWithReturnBlock:(void (^)(NSUInteger buttonIndex, EXAlertView *alertView))block;
- (void) show;
- (void) hide;

@end
