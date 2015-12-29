//
//  Global.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Stripe/Stripe.h>
@interface Global : NSObject
@property (nonatomic, strong) NSString *auth;
@property (nonatomic, strong) NSString* admin_price;
@property (readwrite) int curMenu;
@property (readwrite) long last_updated_time;

@property (readwrite) long event_date;
@property (nonatomic, strong) NSString * event_time;

@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSMutableArray *allevents;
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) NSMutableDictionary *cachedData;
@property (readwrite) STPCardParams* card;
@property (readwrite) BOOL isShowingLandscapeView;
@property (readwrite) BOOL needRefreshFeeds;
@property (readwrite) BOOL needRefreshAccount;

+(id)Global;
+(Global*)sharedInstance;

@end
