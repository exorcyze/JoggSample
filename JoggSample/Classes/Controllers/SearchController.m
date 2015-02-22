//
//  SearchController.m
//  JoggSample
//
//  Created by Mike Johnson on 2/20/15.
//  Copyright (c) 2015 jogg. All rights reserved.
//

#import "SearchController.h"

#import "SampleDataService.h"
#import "EXTableView.h"
#import "EXPullToRefresh.h"
#import "TweetModel.h"
#import "TweetCell.h"

@interface SearchController () <UISearchBarDelegate>

@end

@implementation SearchController {
	NSString *currentSearchTerm;
	
	UISearchBar *mysearch;
	EXTableView *mytable;
	NSMutableArray *mydata;
}

#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupInterface];
	[self refreshData];
}

- (void) viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	
	mytable.width = self.view.width;
	mysearch.width = self.view.width;
	mytable.height = self.view.height - mytable.top;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void) setupInterface {
	self.title = @"Twitter Search";
	self.view.backgroundColor = [UIColor whiteColor];
	
	__weak typeof (self) weakself = self;
	
	mydata = [[NSMutableArray alloc] init];
	
	mysearch = [[UISearchBar alloc] init];
	mysearch.frame = CGRectMake( 0, 0, SCREEN_SIZE.width, 40 );
	mysearch.delegate = self;
	[self.view addSubview:mysearch];
	
	mytable = [[EXTableView alloc] initWithFrame:SCREEN_BOUNDS_ORIENTED style:UITableViewStylePlain];
	mytable.top = mysearch.bottom;
	//[mytable registerClass:[PostCell class] forCellReuseIdentifier:EX_TABLE_VIEW_CELL_IDENTIFIER];
	mytable.tableFooterView = [UIView viewWithFrame:CGRectZero andBackgroundColor:[UIColor whiteColor]];
	mytable.separatorColor = COLOR_TABLE_SEPARATOR;
	[mytable setBlockCellForRowCreate:^UITableViewCell *(NSIndexPath *indexPath) {
		TweetCell *mycell = [[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EX_TABLE_VIEW_CELL_IDENTIFIER];
		return mycell;
	}];
	[mytable setBlockCellForIndexPath:^(UITableView *tableView, UITableViewCell *tableViewCell, NSObject *rowData, NSIndexPath *indexPath) {
		TweetModel *item = (TweetModel *)rowData;
		[(TweetCell *)tableViewCell setData:item];
	}];
	[mytable setBlockCellForRowSelect:^(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath) {
		TweetModel *item = (TweetModel *)rowData;
		NSLog( @"CLICKED : %@", item.text );
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	}];
	[mytable setBlockCellForRowHeight:^float(UITableView *tableView, NSObject *rowData, NSIndexPath *indexPath) {
		TweetModel *item = (TweetModel *)rowData;
		return [TweetCell heightForText:item.text];
	}];
	[self.view addSubview:mytable];
	
	[mytable addPullToRefreshWithBlock:^(EXPullToRefresh *refreshControl) { [weakself refreshData]; }];
	
	// setup our initial search term so we don't start with a blank screen
	currentSearchTerm = @"a";
}

- (void) refreshData {
	[mytable.pullToRefresh startAnimating];
	
	SampleDataService *myservice = [[SampleDataService alloc] init];
	[myservice getTwitterResultsForTerm:currentSearchTerm onComplete:^(NSArray *returnData, NSError *returnError) {
		[mytable.pullToRefresh stopAnimating];
		
		if ( returnError ) {
			[UIAlertView showAlertViewWithTitle:@"Oh No!" andText:[NSString stringWithFormat:@"There was a problem fetching the data: %@", returnError.localizedDescription]];
			return;
		}
		
		mydata = [NSMutableArray arrayWithArray:returnData];
		[mytable setData:mydata];
		
	}];
}

#pragma mark - UISearchBarDelegate Methods

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	currentSearchTerm = searchBar.text;
	[searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
	[self refreshData];
}

@end
