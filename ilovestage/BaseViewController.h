//
//  BaseViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "consts.h"
#import "MBProgressHUD.h"

typedef enum {
    kLoadStatusNone = 0,
	kLoadStatusLoadMore = 1,
	kLoadStatusAllLoaded	= 2,
    kLoadStatusRefresh	= 3,
    kLoadStatusError	= 4,
    kLoadStatusLoading	= 5,
} UILoadMoreStatus;

typedef enum {
    kViewModeGrid = 0,
	kViewModeList = 1,
	
} UIViewMode;


@interface BaseViewController : UIViewController <UIActionSheetDelegate>{
   
}

@property (nonatomic, readwrite) UILoadMoreStatus status;
@property(nonatomic, strong) MBProgressHUD *hud;


-(NSString *)URLEncodingOfString:(NSString *)s;
-(NSString *)displayStringForDouble:(double)aDouble;
-(void)showBusyView:(BOOL)show animated:(BOOL)animated msg:(NSString *)msg;

-(NSString*)updatedDate:(NSDate*)lastDate;


-(void)hide;
-(void) showPopup:(NSString*)msg;
-(void) showLoading:(NSString*)msg;
-(BOOL) validateEmail: (NSString *) candidate;
-(IBAction)backButtonPressed:(id)sender;
-(void)showError:(NSString*)msg;
@end
