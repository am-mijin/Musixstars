//
//  AppDelegate.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import <Stripe/Stripe.h>
#import "Constants.h"
#import <Parse/Parse.h>
#import <GooglePlus/GPPURLHandler.h>

#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
//#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "Cache.h"

// String used to identify the update object in the user defaults storage.
static NSString * const kLastStoreUpdateKey = @"LastStoreUpdate";

// Get the RSS feed for the first time or if the store is older than kRefreshTimeInterval seconds.
static NSTimeInterval const kRefreshTimeInterval = 3600;

// The number of songs to be retrieved from the RSS feed.
static NSUInteger const kImportSize = 300;
@interface AppDelegate()

// Properties for the Core Data stack.
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString *persistentStorePath;

@end

//NSString * const StripePublishableKey = @"pk_test_h7pKUfa0zHQqjX60TMjgN6fV";
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    
    /*
    if ([KOSession isKakaoLinkCallback:url]) {
        NSLog(@"KakaoLink callback! query string: %@", [url query]);
        return YES;
    }*/
    
    if([[UserAccount sharedInstance].provider isEqualToString:@"Google"])
    {
        NSLog(@"application Google");
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }
    else
    {
        NSLog(@"application Facebook");
        
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                        fallbackHandler:^(FBAppCall *call) {
                            NSLog(@"In fallback handler");
                        }];
    }
    
    return 0;
}

// saves changes in the application's managed object context before the application terminates.
//
- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
    
    NSError *error;
    if (self.managedObjectContext != nil) {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
  

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    [self restore];
    
    
    //if(![[UserAccount sharedInstance].countrycallingcode length])
    {
        NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
        NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode]; // get country code,
        NSString *identifier = [NSLocale localeIdentifierFromComponents:
                                [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        [UserAccount sharedInstance].countryCode = countryCode;
        [UserAccount sharedInstance].countrycallingcode = [Utilities lookupDialCodes:countryCode];
        
        [UserAccount sharedInstance].country = [[[NSLocale alloc] initWithLocaleIdentifier:countryCode] displayNameForKey: NSLocaleIdentifier value: identifier];
     
    }
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if(![[UserAccount sharedInstance].language isEqualToString: language])
    {
        
        [Global sharedInstance].last_updated_time = 0;
    }
    //if([language isEqualToString:@"en-GB"])
    //    [UserAccount sharedInstance].language = @"en" ;
    [UserAccount sharedInstance].language = language;
    
    NSLog(@"countryCode %@", [UserAccount sharedInstance].countryCode);
    
    //ko
    //zh-Hans
    //zh-Hant
    
    // Override point for customization after application launch.
 
    
    /*
        [UIView animateWithDuration:0.8f animations:
         ^{
    
    
             [_loadingView setFrame:CGRectMake(0,-_window.frame.size.height,320, _window.frame.size.height)];
    
    
    
         } completion:
         ^(BOOL finished)
         {
             
         }];*/
 
    
    if (StripePublishableKey) {
        [Stripe setDefaultPublishableKey:StripePublishableKey];
    }
    if (ParseApplicationId && ParseClientKey) {
        [Parse setApplicationId:ParseApplicationId
                      clientKey:ParseClientKey];
    }
 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    NSString *remoteHostName = @"www.apple.com";
    //NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    
    _hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [_hostReachability startNotifier];
    [self updateInterfaceWithReachability:_hostReachability];
    
    _internetReachability = [Reachability reachabilityForInternetConnection];
    [_internetReachability startNotifier];
    [self updateInterfaceWithReachability:_internetReachability];
    
    _wifiReachability = [Reachability reachabilityForLocalWiFi];
    [_wifiReachability startNotifier];
    [self updateInterfaceWithReachability:_wifiReachability];
    
    
    
    return YES;
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == _hostReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
        
        //NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            //            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            //            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        //self.summaryLabel.text = baseLabelText;
        
        
    }
    if (reachability == _internetReachability)
    {
        //        [self configureTextField:self.internetConnectionStatusField imageView:self.internetConnectionImageView reachability:reachability];
    }
    
    if (reachability == _wifiReachability)
    {
        //        [self configureTextField:self.localWiFiConnectionStatusField imageView:self.localWiFiConnectionImageView reachability:reachability];
    }
}

- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    //textField.text= statusString;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        //save the installation
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation[@"user"] = [[PFUser currentUser]objectId];
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0;
            [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    // Handle error here with an alert…
                }
                else {
                    // only update locally if the remote update succeeded so they always match
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                     NSLog(@"updated badge");
                }
            }];
        }
    }
    else
    {
         [PFUser logOut];
    }
    // FBSample logic
    // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
    [FBAppEvents activateApp];
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
    
    
}

-(void)save
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[UserAccount sharedInstance].firstname forKey:@"firstname"];
    [defaults setObject:[UserAccount sharedInstance].lastname forKey:@"lastname"];
    [defaults setObject:[UserAccount sharedInstance].userid forKey:@"userid"];
    [defaults setObject:[UserAccount sharedInstance].email forKey:@"email"];
    [defaults setObject:[UserAccount sharedInstance].password forKey:@"password"];
    
    //[defaults setObject:[UserAccount sharedInstance].provider forKey:@"provider"];
    //[defaults setObject:[UserAccount sharedInstance].provider_uid forKey:@"provider_uid"];
    //[defaults setObject:[UserAccount sharedInstance].country forKey:@"country"];
    //[defaults setObject:[UserAccount sharedInstance].countrycallingcode forKey:@"countrycallingcode"];
    //[defaults setObject:[UserAccount sharedInstance].phonenumber forKey:@"phonenumber"];
    [defaults setObject:[UserAccount sharedInstance].role forKey:@"role"];
    //[defaults setObject:[UserAccount sharedInstance].language forKey:@"language"];
    
    //[defaults setObject:[UserAccount sharedInstance].address forKey:@"address"];
    [defaults setObject:[UserAccount sharedInstance].angency_name forKey:@"angency_name"];
    [defaults setObject:[Global sharedInstance].card.number forKey:@"number"];
   
    if([Global sharedInstance].card.number)
    {
        //[defaults setObject:[Global sharedInstance].card.number forKey:@"number"];
        [defaults setInteger:[Global sharedInstance].card.expMonth forKey:@"expMonth"];
        [defaults setInteger:[Global sharedInstance].card.expYear forKey:@"expYear"];
        [defaults setObject:[Global sharedInstance].card.cvc forKey:@"cvc"];
        [defaults setObject:[Global sharedInstance].card.addressZip forKey:@"addressZip"];
    
        [defaults setObject:[Global sharedInstance].card.addressCountry forKey:@"addressCountry"];
    }
    
    if([[Cache sharedInstance].data count])
    {
        /*
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:
                         [Cache sharedInstance].data ];
    
        
        [defaults setObject:data forKey:@"cachedData"];*/
    }
    
    if( [[UserAccount sharedInstance].perks count])
        
        [defaults setObject:[UserAccount sharedInstance].perks forKey:@"perks"];
   
    
    NSLog(@"save %@",defaults);
    [defaults synchronize];
}

-(void)restore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [UserAccount sharedInstance].firstname = [defaults objectForKey:@"firstname"];
    [UserAccount sharedInstance].lastname= [defaults objectForKey:@"lastname"];
    [UserAccount sharedInstance].email = [defaults objectForKey:@"email"];
    [UserAccount sharedInstance].password= [defaults objectForKey:@"password"];
    [UserAccount sharedInstance].userid = [defaults objectForKey:@"userid"];
    [UserAccount sharedInstance].role= [defaults objectForKey:@"role"];
    
    
    /*
    [UserAccount sharedInstance].phonenumber= [defaults objectForKey:@"phoneumber"];
    
    [UserAccount sharedInstance].address= [defaults objectForKey:@"address"];
    [UserAccount sharedInstance].angency_name= [defaults objectForKey:@"angency_name"];
    if([defaults objectForKey:@"countrycallingcode"])
    {
        [UserAccount sharedInstance].countrycallingcode= [defaults objectForKey:@"countrycallingcode"];
        [UserAccount sharedInstance].country= [defaults objectForKey:@"country"];
    }
    
    if([defaults objectForKey:@"language"])
    {
        [UserAccount sharedInstance].language= [defaults objectForKey:@"language"];
    }
    */
    if([defaults objectForKey:@"number"])
    {
        STPCard *card = [[STPCard alloc] init];
        card.number = [defaults objectForKey:@"number"];
        card.expMonth = [[defaults objectForKey:@"expMonth"] intValue];
        card.expYear =  [[defaults objectForKey:@"expYear"] intValue];
        card.cvc = [defaults objectForKey:@"cvc"];
        card.addressZip = [defaults objectForKey:@"addressZip"];
        card.addressCountry  = [defaults objectForKey:@"addressCountry"];
        [Global sharedInstance].card = card;
    }
    
    if([defaults objectForKey:@"cachedData"] != nil)
    {
        //[Cache sharedInstance].data = [[defaults objectForKey:@"cachedData"] mutableCopy];
    }
    
    if([defaults objectForKey:@"perks"])
         [UserAccount sharedInstance].perks = [[defaults objectForKey:@"perks"] mutableCopy];
    
    if([[UserAccount sharedInstance].password length])
        [UserAccount sharedInstance].loggedin = YES;
    else
        [UserAccount sharedInstance].loggedin = NO;
    
   
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    //BLog();
    /*
     Store the completion handler. The completion handler is invoked by the view controller's checkForAllDownloadsHavingCompleted method (if all the download tasks have been completed).
     */
	self.backgroundSessionCompletionHandler = completionHandler;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"My token is: %@", deviceToken);
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification %@",userInfo);
  
    
    [PFPush handlePush:userInfo];
    
    if([[userInfo objectForKey:@"aps"] objectForKey:@"badgecount"]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ReacieveNotificationNotification
                                                           object:nil  userInfo: nil];
    }
    
    UIApplicationState state = [application applicationState];
    // user tapped notification while app was in background
    if (state == UIApplicationStateInactive || state == UIApplicationStateBackground) {
        // go to screen relevant to Notification content
        
       
        
    }
    else {
        // App is in UIApplicationStateActive (running in foreground)
       
        NSString *message = nil;
        NSDictionary *aps = [userInfo objectForKey:@"aps"];

        
        id alert = [aps objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSString class]]) {
            message = alert;
        } else if ([alert isKindOfClass:[NSDictionary class]]) {
            message = [alert objectForKey:@"body"];
        }
        
        if (alert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
           
            [alert show];

        }
    }
    //DetailPageClass *detailPage = [[DetailPageClass alloc] initWithNibName:@"DetailPageClass" bundle:nil];
    //[self.navigationcontroller pushViewController:detailPage animated:YES];
    
    
}
/*
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    NSString *viewControllerClassName = [NSString stringWithUTF8String:object_getClassName(window.rootViewController)];
    if ([viewControllerClassName isEqualToString:@"_UIAlertShimPresentingViewController"])   {
        return UIInterfaceOrientationMaskPortrait;
    }
    else {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
}*/

#pragma mark - Core Data stack
#pragma mark - Core Data stack setup

//
// These methods are very slightly modified from what is provided by the Xcode template
// An overview of what these methods do can be found in the section "The Core Data Stack"
// in the following article:
// http://developer.apple.com/iphone/library/documentation/DataManagement/Conceptual/iPhoneCoreData01/Articles/01_StartingOut.html
//
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeUrl = [NSURL fileURLWithPath:self.persistentStorePath];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        NSError *error = nil;
        NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
        NSAssert3(persistentStore != nil, @"Unhandled error adding persistent store in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        (self.managedObjectContext).persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _managedObjectContext;
}

- (NSString *)persistentStorePath {
    
    if (_persistentStorePath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths.lastObject;
        _persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"Musixstars.sqlite"];
    }
    return _persistentStorePath;
}


@end
