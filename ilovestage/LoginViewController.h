//
//  LoginViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "consts.h"
#import "config.h"
#import "AppDelegate.h"
#import "SubViewController.h"

#import <GooglePlus/GPPSignIn.h>
#import <FacebookSDK/FacebookSDK.h>



@class GPPSignInButton;
@interface LoginViewController : BaseViewController <UITextFieldDelegate,RequestDelegate, FBLoginViewDelegate,GPPSignInDelegate,UIAlertViewDelegate>
@property (strong, nonatomic)  UINavigationController* frontview_navController;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgot_password_btn;
//@property (weak, nonatomic) IBOutlet UILabel *errormsg;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupforUser;
@property (weak, nonatomic) IBOutlet UIButton *signupforAgency;
@property (weak, nonatomic) IBOutlet UIButton *arrow1;
@property (weak, nonatomic) IBOutlet UIButton *arrow2;

@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) ACAccountStore *accountStore;

@property (weak, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (strong, nonatomic) GPPSignIn *signIn;
//- (IBAction)clickhere:(id)sender;
@end
