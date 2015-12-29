//
//  UIPullToReloadTableViewController.m
//  Discoveredd
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIPullToReloadTableViewController.h"

@implementation UIPullToReloadTableViewController

@synthesize pullToReloadHeaderView,aTable;

- (void) viewDidLoad {
    [super viewDidLoad];
      
    pullToReloadHeaderView = [[UIPullToReloadHeaderView alloc] initWithFrame:
                              CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                        320.0f, self.view.bounds.size.height)];
    
    [self.aTable addSubview:pullToReloadHeaderView];
    
}

-(void) viewDidUnload {
	[super viewDidUnload];
	pullToReloadHeaderView = nil;	
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    
	if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
	checkForRefresh = YES;  //  only check offset when dragging
} 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
	
	if (checkForRefresh) {
		if (scrollView.contentOffset.y > -kPullDownToReloadToggleHeight && scrollView.contentOffset.y < 0.0f) {
			[pullToReloadHeaderView setStatus:kPullStatusPullDownToReload animated:YES];
			
		} else if (scrollView.contentOffset.y < -kPullDownToReloadToggleHeight) {
			[pullToReloadHeaderView setStatus:kPullStatusReleaseToReload animated:YES];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    //if(g_curTab == BROWSE)
    //    [self scrollViewDidEndDragging];
    
	if ([pullToReloadHeaderView status] == kPullStatusLoading) return;
	
	if ([pullToReloadHeaderView status]==kPullStatusReleaseToReload) {
		[pullToReloadHeaderView startReloading:self.aTable animated:YES];
		[self pullDownToReloadAction];
	}
	checkForRefresh = NO;
}

#pragma mark actions

-(void) pullDownToReloadAction {
	NSLog(@"TODO: Overload this");
}

@end
