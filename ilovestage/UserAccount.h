//
//  UserAccount.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>



@interface UserAccount : NSObject

@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *provider_uid;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *countrycallingcode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *countryCode;

@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *angency_name;
@property (nonatomic, strong) NSString *phonenumber;


@property (nonatomic, strong) NSString	*bankname;
@property (nonatomic, strong) NSString	*sortcode;
@property (nonatomic, strong) NSString	*accountnumber;
@property (nonatomic, strong) NSString	*accountname;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) NSMutableArray *perks;
@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic) BOOL autoLogin;
@property (nonatomic) BOOL loggedin;
@property (nonatomic) BOOL welcome;
@property (nonatomic, strong) NSString *login_error;
+(id)userAccount;
+(UserAccount*)sharedInstance;
-(void)setUser:(PFUser*)user;
-(void)reset;

@end