//
//  UIPullToReloadHeaderView.h
//  Discoveredd
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

typedef enum {
	kPullStatusReleaseToReload = 0,
	kPullStatusPullDownToReload	= 1,
	kPullStatusLoading = 2
} UIPullToReloadStatus;

#define kPullDownToReloadToggleHeight 65.0f

@interface UIPullToReloadHeaderView : UIView {	
@private
	UIPullToReloadStatus status;
	
	UILabel *lastUpdatedLabel;
	UILabel *statusLabel;
	UIImageView *arrowImage;
    UIImageView *loadingView;
	UIActivityIndicatorView *activityView;
	
	NSDate *lastUpdatedDate;
	
	SystemSoundID popSound, pull1Sound, pull2Sound;
}

@property (nonatomic, strong) NSDate *lastUpdatedDate;
@property (nonatomic, readonly) UIPullToReloadStatus status;

- (void)setStatus:(UIPullToReloadStatus)status animated:(BOOL)animated;
- (void) scrollViewDidEndDragging;
- (void) startReloading:(UITableView *)tableView animated:(BOOL)animated;	// call when start loading
- (void) finishReloading:(UITableView *)tableView animated:(BOOL)animated;	// call when finish loading


@end
