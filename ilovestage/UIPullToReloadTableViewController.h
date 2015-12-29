//
//  UIPullToReloadTableViewController.h
//  Discoveredd
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIPullToReloadHeaderView.h"
#import "BaseViewController.h"
//#include "Item.h"
@interface UIPullToReloadTableViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
     UITableView *aTable;
//@private
	UIPullToReloadHeaderView *pullToReloadHeaderView;	
	BOOL checkForRefresh;
}

-(void) pullDownToReloadAction;

@property (nonatomic, readonly) UIPullToReloadHeaderView *pullToReloadHeaderView;
@property (nonatomic, strong) IBOutlet UITableView *aTable;
@end
