//
//  config.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#ifndef PSP_config_h
#define PSP_config_h

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

//Notification Name
#define FACEBOOK_DIALOG_DID_COMPLETE			@"FACEBOOK_DIALOG_DID_COMPLETE"
#define PROFILE_UPDATE				@"PROFILE_UPDATE"
#define FACEBOOK_DIALOG_DID_COMPLETE			@"FACEBOOK_DIALOG_DID_COMPLETE"
#define CREATE_USER_ACCOUNT			@"CREATE_USER_ACCOUNT"

#define FB_LOGIN_NOTIFICATION				@"FB_LOGIN_NOTIFICATION"
#define FB_GET_USERINFO				@"FB_GET_USERINFO"
#define LOGIN_NOTIFICATION				@"LOGIN_NOTIFICATION"
#define POST_NOTIFICATION				@"POST_NOTIFICATION"
#define FB_DID_NOT_LOGIN			@"FB_DID_NOT_LOGIN"

#define TEST 0
//#define kErrorCode_404	NSLocalizedString(@"You haven't registerd yet. Please register to use ILOVESTAGE service.",@"You haven't registerd yet. Please register to use ILOVESTAGE service.")
//#define kErrorCode_401	NSLocalizedString(@"Invalid login. Please check your login details.",@"Invalid login. Please check your login details.")
////#define kErrorCode_400	NSLocalizedString(@"Invalid login. Please check your login details.",@"Invalid login. Please check your login details.")
//#define kErrorCode_409	NSLocalizedString(@"This email already exists.",@"This email already exists.")
//
//
//#define kEamilValidataionError	NSLocalizedString(@"Please enter a valid email address",@"Please enter a valid email address")
//#define kRegistrationError	NSLocalizedString(@"Please enter all information",@"Please enter all information")


static NSString * const kClientID = @"408920779097-ob8gf0m6ssj39dnt43gba4sdakd46gr2.apps.googleusercontent.com";


static NSString * const kStandard = @"standard";
static NSString * const kAdmin = @"admin";
static NSString * const kAgent = @"agent";
static NSString * const kArtist = @"artist";
#define NOTIFICATION_UPDATE_SHOW			@"NOTIFICATION_UPDATE_SHOW"
#define NOTIFICATION_PICKERVIEW_UPDATE				@"NOTIFICATION_PICKERVIEW_UPDATE"
#define NOTIFICATION_DOWNLOADTASK				@"NOTIFICATION_DOWNLOADTASK"
#define NOTIFICATION_GET_VIDEOINFO				@"NOTIFICATION_GET_VIDEOINFO"
#define NOTIFICATION_LIVESTATUS				@"NOTIFICATION_LIVESTATUS"
#define NOTIFICATION_STOP_VIDEOPLAYER				@"NOTIFICATION_STOP_VIDEOPLAYER"
#endif
