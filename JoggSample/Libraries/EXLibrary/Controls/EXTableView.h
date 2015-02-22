//
//  EXTableView.h
//
//  Created by Mike Johnson on 9/22/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//


#import <UIKit/UIKit.h>

#define EX_TABLE_VIEW_CELL_IDENTIFIER @"EXCellIdentifier"

/*
	// SAMPLE USAGE : 
	mydata = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
	mytable = [[EXTableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 480 ) style:UITableViewStylePlain];
	[mytable setData:mydata];
	[mytable setBlockCellForRowCreate:^UITableViewCell *(NSIndexPath *indexPath) {
		return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:EX_TABLE_VIEW_CELL_IDENTIFIER];
	}];
	[mytable setBlockCellForIndexPath:^(UITableView *tableView, UITableViewCell *tableViewCell, NSObject *rowData, NSIndexPath *indexPath) {
		NSString *item = (NSString *)rowData;
		tableViewCell.textLabel.text = item;
		tableViewCell.detailTextLabel.text = @"testing";
	}];
	[mytable setBlockCellForRowSelect:^(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath) {
		NSLog( @"Selected %i", indexPath.row );
	}];
	[self.view addSubview:mytable];
*/

@interface EXTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) int sectionCount;

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void) setData:(NSArray *)newDataSource;
- (void) setBlockCellForIndexPath:(void (^)(UITableView *tableView, UITableViewCell *tableViewCell, NSObject *rowData, NSIndexPath *indexPath))block;
- (void) setBlockCellForRowCreate:(UITableViewCell *(^)(NSIndexPath *indexPath))block;
- (void) setBlockCellForRowSelect:(void (^)(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath))block;
- (void) setBlockCellForRowHeight:(float (^)(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath))block;
- (void) setBlockViewForHeader:(UIView * (^)(UITableView *tableView, NSInteger *section))block;

@end
