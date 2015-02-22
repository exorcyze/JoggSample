//
//  EXTableView.m
//
//  Created by Mike Johnson on 9/22/12.
//  Copyright (c) 2012 Exorcyze Studios. All rights reserved.
//

#import "EXTableView.h"
#import <objc/runtime.h>

#define BLOCK_CELL_INDEX_PATH @"blockCellForIndexPath"
#define BLOCK_CELL_ROW_CREATE @"blockCellForRowCreate"
#define BLOCK_CELL_ROW_SELECT @"blockCellForRowSelect"
#define BLOCK_CELL_ROW_HEIGHT @"blockCellForRowHeight"
#define BLOCK_CELL_SECTION_HEADER @"blockCellForSectionHeader"

@interface EXTableView ()

@end

@implementation EXTableView {
	NSArray *mydata;
	UITableViewCellStyle cellStyle;
}

#pragma mark - View Lifecycle

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
	self = [super initWithFrame:frame style:style];
    if ( self ) {
		self.sectionCount = 1;
		cellStyle = UITableViewCellStyleDefault;
		mydata = [[NSArray alloc] init];
		
		self.dataSource = self;
		self.delegate = self;
    }
    return self;
}

#pragma mark - Public Methods

- (void) setData:(NSArray *)newDataSource {
	mydata = newDataSource;
	[self reloadData];
}

- (void) setBlockCellForIndexPath:(void (^)(UITableView *tableView, UITableViewCell *tableViewCell, NSObject *rowData, NSIndexPath *indexPath))block {
	objc_setAssociatedObject(self, BLOCK_CELL_INDEX_PATH, [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) setBlockCellForRowCreate:(UITableViewCell *(^)(NSIndexPath *indexPath))block {
	objc_setAssociatedObject(self, BLOCK_CELL_ROW_CREATE, [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) setBlockCellForRowSelect:(void (^)(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath))block {
	objc_setAssociatedObject(self, BLOCK_CELL_ROW_SELECT, [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) setBlockCellForRowHeight:(float (^)(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath))block {
	objc_setAssociatedObject(self, BLOCK_CELL_ROW_HEIGHT, [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) setBlockViewForHeader:(UIView * (^)(UITableView *tableView, NSInteger *section))block {
	objc_setAssociatedObject(self, BLOCK_CELL_SECTION_HEADER, [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ( self.sectionCount == 1 ) { return mydata.count; }
	
	return [(NSArray *)mydata[ (int)section ] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = EX_TABLE_VIEW_CELL_IDENTIFIER;
    
	//UITableViewCell *cell;
	//cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if ( objc_getAssociatedObject(self, BLOCK_CELL_ROW_CREATE) ) {
			UITableViewCell *(^block)(NSIndexPath *indexPath) = objc_getAssociatedObject(self, BLOCK_CELL_ROW_CREATE);
			cell = block( indexPath );
		}
		else {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
    }
	
	if ( objc_getAssociatedObject(self, BLOCK_CELL_INDEX_PATH) ) {
		NSObject *thisRow;
		if ( self.sectionCount == 1 ) { thisRow = [mydata objectAtIndex:indexPath.row]; }
		else { thisRow = [(NSArray *)mydata[ (int)indexPath.section ] objectAtIndex:indexPath.row]; }
		
		void (^block)(UITableView *tableView, UITableViewCell *tableViewCell, NSObject *rowData, NSIndexPath *indexPath) = objc_getAssociatedObject(self, BLOCK_CELL_INDEX_PATH);
		block( tableView, cell, thisRow, indexPath );
	}
	
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( !objc_getAssociatedObject(self, BLOCK_CELL_ROW_SELECT) ) { return; }
	
	NSObject *thisRow;
	if ( self.sectionCount == 1 ) { thisRow = [mydata objectAtIndex:indexPath.row]; }
	else { thisRow = [(NSArray *)mydata[ (int)indexPath.section ] objectAtIndex:indexPath.row]; }

	void (^block)(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath) = objc_getAssociatedObject(self, BLOCK_CELL_ROW_SELECT);
	block( tableView, thisRow, indexPath );
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( !objc_getAssociatedObject(self, BLOCK_CELL_ROW_HEIGHT) ) { return 42.0; }
	
	NSObject *thisRow;
	if ( self.sectionCount == 1 ) { thisRow = [mydata objectAtIndex:indexPath.row]; }
	else { thisRow = [(NSArray *)mydata[ (int)indexPath.section ] objectAtIndex:indexPath.row]; }

	float (^block)(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath) = objc_getAssociatedObject(self, BLOCK_CELL_ROW_HEIGHT);
	float ret = block( tableView, thisRow, indexPath );
	return ret;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ( self.sectionCount == 1 ) { return [UIView viewWithFrame:CGRectZero andBackgroundColor:[UIColor clearColor]]; }
	if ( !objc_getAssociatedObject(self, BLOCK_CELL_SECTION_HEADER) ) { return [UIView viewWithFrame:CGRectZero andBackgroundColor:[UIColor clearColor]]; }
	
	UIView * (^block)(UITableView *tableView, NSInteger section) = objc_getAssociatedObject(self, BLOCK_CELL_SECTION_HEADER);
	UIView *ret = block( tableView, section );
	return ret;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ( self.sectionCount == 1 ) { return 0; }
	else { return 30; }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

@end
