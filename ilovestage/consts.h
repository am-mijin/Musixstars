//
//  Consts.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#ifndef PSP_Consts_h
#define PSP_Consts_h

#import "Global.h"
#import "UserAccount.h"
#import "AppLinkCenter.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

#import "Cache.h"
static NSString* kBaseURL = @"http://api.ilovestage.co.uk/1.0.0/";

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define H1_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]
#define H2_COLOR [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
#define BODY_COLOR [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]
#define TABLEVIEW_BACKGROUND_COLOR [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0]
#define TABLEVIEW_SEPERATOR_COLOR [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1.0]
#define TABLEVIEW_BACKGROUND_COLOR2 [UIColor colorWithRed:40/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define BUTTON_BG_COLOR [UIColor colorWithRed:238/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]
#define AFL_BG_COLOR [UIColor colorWithRed:18.0/255.0 green:57.0/255.0 blue:104.0/255.0 alpha:1.0]
#define SOLID_RED_COLOR [UIColor colorWithRed:244.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]
#define AIBA_RED [UIColor colorWithRed:238.0/255.0 green:58.0/255.0 blue:67.0/255.0 alpha:1.0]
#define AIBA_BLUE [UIColor colorWithRed:0.0/255.0 green:93.0/255.0 blue:171.0/255.0 alpha:1.0]
#define AIBA_DARK_RED [UIColor colorWithRed:151.0/255.0 green:14.0/255.0 blue:20.0/255.0 alpha:1.0]
#define AIBA_DARK_BLUE [UIColor colorWithRed:16.0/255.0 green:39.0/255.0 blue:74.0/255.0 alpha:1.0]
#define AIBA_FADED_BLUE [UIColor colorWithRed:75.0/255.0 green:92.0/255.0 blue:119.0/255.0 alpha:1.0]

#define CAL_SELECTED [UIColor colorWithRed:248.0/255.0 green:205.0/255.0 blue:41.0/255.0 alpha:1.0]

#define CAL_NORMAL [UIColor colorWithRed:201.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0]
#define CAL_DISCABLED [UIColor colorWithRed:85.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0]

#define WATCHLIVE_RED [UIColor colorWithRed:228.0/255.0 green:31.0/255.0 blue:47.0/255.0 alpha:1.0]
#define SOLID_RED [UIColor colorWithRed:240.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]
#define AFL_BLUE [UIColor colorWithRed:18.0/255.0 green:57.0/255.0 blue:104.0/255.0 alpha:1.0]
#define ILS_RED [UIColor colorWithRed:237.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TIME 0
#define DATE 1
#define DEFAULT 2

#define IMAGESIZE_BIG 0
#define IMAGESIZE_SMALL 1

#define FEEDS 0
#define MYACCOUNT 1
#define ABOUT 2
#define NOTIFICATIONS 3

#define ONEMINUTE 60
#define ONEHOUR  (60 * ONEMINUTE)
#define TWOHOURS (60 * ONEMINUTE*2)
#define ONEDAY  (24 * ONEHOUR)

#define ABOUT_US 0
#define TERMS_OF_USE 1
#define PRIVACY_POLICY 2
#define FAQ 3


#define TABLE_SECTION 0
#define TABLE_CELL_TYPE1 1
#define TABLE_CELL_TYPE2 2

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

#define TIMEFORMAT_EVENTS_TITLE 5
#define TIMEFORMAT_EVENTS 7
#define TIMEFORMAT_TICKETS 8


#define ReacieveNotificationNotification			@"ReacieveNotificationNotification"

typedef enum editMode
{
    kAddNew,
    kEdit,
    kDelete
    
}editMode;


typedef enum viewMode
{
    kDefault,
    kUploadVideo,
    kEditVideo
    
}viewMode;

typedef enum requestType
{
    kLogin,
    kSignup,
    kUser,
    kBooking,
    kPayment,
    kShows,
    kEvents
    
}requestType;

#endif
