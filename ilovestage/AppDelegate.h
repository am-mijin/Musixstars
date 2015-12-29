//
//  AppDelegate.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@import UIKit;
@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (copy) void (^backgroundSessionCompletionHandler)();
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIImageView *loadingView;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
-(void)restore;
-(void)save;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
