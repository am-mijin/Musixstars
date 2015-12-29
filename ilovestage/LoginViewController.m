//
//  LoginViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "LoginViewController.h"
#import "UserAccount.h"

#import "RegistrationViewController.h"
#import "ResetPasswordViewController.h"


#import "AppDelegate.h"

#import "UserAccount.h"

#import <GoogleOpenSource/GTMOAuth2Authentication.h>
#import <GoogleOpenSource/GTLPlusConstants.h>
@interface LoginViewController ()
@property (readwrite) int requeset;
@end

@implementation LoginViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([[UserAccount sharedInstance].language isEqual:@"ko"])
    {
        self.arrow1.hidden = YES;
        self.arrow2.hidden = YES;
        //self.arrow1.frame = CGRectMake(_arrow1.frame.origin.x-20, _arrow1.frame.origin.y, _arrow1.frame.size.width, _arrow1.frame.size.height);
        //self.arrow2.frame = CGRectMake(_arrow2.frame.origin.x-20, _arrow2.frame.origin.y, _arrow2.frame.size.width, _arrow2.frame.size.height);
    }
    else
    {
        self.arrow1.hidden = NO;
        self.arrow2.hidden = NO;
        //self.arrow1.frame = CGRectMake(238, 349, _arrow1.frame.size.width, _arrow1.frame.size.height);
        //self.arrow2.frame = CGRectMake(238, 382, _arrow2.frame.size.width, _arrow2.frame.size.height);
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
 
    [self.navigationController.navigationBar setHidden:YES];
   
    if( [UserAccount sharedInstance].loggedin )
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app save];
        }];
    }
    else{
        [[UserAccount sharedInstance] reset];
    }
    
  
  
    self.emailTextField.text = [UserAccount sharedInstance].email;
    self.passwordTextField.text = [UserAccount sharedInstance].password;
  
    
    self.emailTextField.text = @"musixstarsapp@gmail.com";
    self.passwordTextField.text = @"1234";
    
    //self.emailTextField.text = @"developer.mcho@gmail.com";
    //self.passwordTextField.text = @"1234";
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"";
    //_loginLabel.font = [UIFont fontWithName:@"Seravek-Bold" size:20];
    //_LoginBtn.titleLabel.font = [UIFont fontWithName:@"Seravek-Bold" size:20];

    [_forgot_password_btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    //_forgot_password_btn.font =[UIFont fontWithName:@"Seravek-Light" size:14];
    //_signupforUser.font =[UIFont fontWithName:@"Seravek" size:16];
    //_signupforAgency.font =[UIFont fontWithName:@"Seravek" size:16];
  
    
    //_emailTextField.font = [UIFont fontWithName:@"Seravek" size:18];
    //_passwordTextField.font = [UIFont fontWithName:@"Seravek" size:18];
    
    _emailTextField.placeholder = NSLocalizedString(@"EMAIL", @"");
    _passwordTextField.placeholder = NSLocalizedString(@"PASSWORD", @"");
    _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _LoginBtn.titleLabel.text= NSLocalizedString(@"LOGIN", @"");
    _signupforUser.titleLabel.text= NSLocalizedString(@"SIGN UP FOR USER", @"");
    _signupforAgency.titleLabel.text= NSLocalizedString(@"SIGN UP FOR AGENCY", @"");
    _forgot_password_btn.titleLabel.text= NSLocalizedString(@"FORGOT PASSWORD", @"");

    _emailTextField.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:NSLocalizedString(@"EMAIL", @"")
     attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]
     initWithString:NSLocalizedString(@"PASSWORD", @"")
     attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    
    FBLoginView *loginview=[[FBLoginView alloc]initWithReadPermissions:@[@"email"]];

    //loginview.backgroundColor = [UIColor redColor];
    loginview.frame = CGRectMake(31,508, 50, 50);

#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        //loginview.frame = CGRectOffset(loginview.frame, 5, 25);
    }
#endif
#endif
#endif
    loginview.delegate = self;
    

    
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
//            [obj setImage:[UIImage imageNamed:@"ic_facebook.png"] forState:UIControlStateNormal];
//            [obj setImage:[UIImage imageNamed:@"ic_facebook.png"] forState:UIControlStateSelected];
//            [obj setImage:[UIImage imageNamed:@"ic_facebook.png"] forState:UIControlStateHighlighted];
            

            [obj setBackgroundImage:nil forState:UIControlStateNormal];
            [obj setBackgroundImage:nil forState:UIControlStateSelected];
            [obj setBackgroundImage:nil forState:UIControlStateHighlighted];
           
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            [obj setTextColor:[UIColor clearColor] ];
        }
    }
    [self.view addSubview:loginview];
    
    /* Twitter */
    _accountStore = [[ACAccountStore alloc] init];
    
    /*Google */
    _signIn = [GPPSignIn sharedInstance];
    _signIn.shouldFetchGooglePlusUser = YES;
    _signIn.shouldFetchGoogleUserEmail = YES;
    _signIn.clientID = kClientID;
    _signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     nil];
    _signIn.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark === TextField Delegate ===
#pragma mark -

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
	if (textField == self.emailTextField)
	{
		[self.passwordTextField becomeFirstResponder];
	}
	
	if (textField == self.passwordTextField)
	{
        
		[textField resignFirstResponder];
		[self LoginAction:nil];
	}
    
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  
    
}


-(void)loginwithemail
{
    NSString* email =  [self.emailTextField.text copy];
    NSString* password =  [self.passwordTextField.text copy];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self showLoading:@"Logging in..."];
        
    });
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   
                                   email, @"email",
                                   password, @"password",
                                   nil];
    
    
    
    [AppLinkCenter requestWithPath:@"users"
                         andParams:params
                     andHttpMethod:@"GET"
                       andDelegate:self];
    
    NSLog(@"params %@",params);
}

-(void)postData
{
    dispatch_async(dispatch_get_main_queue(),^{
        [self showLoading:@""];
        
    });
    
    

        PFQuery *query = [PFUser query];
    
        [query whereKey:@"provider_uid" equalTo:[UserAccount sharedInstance].provider_uid];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [self hide];
            
            if (!object) {
                
                if([error code]   == 101)
                {
                    
                    [[[UIAlertView alloc] initWithTitle:@""
                                                message:NSLocalizedString(@"ErrorCode_404", @"")
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil]
                     show];
                    
                }
                
            } else {
                PFUser *user = (PFUser *)object;
                [UserAccount sharedInstance].loggedin = YES;
                [UserAccount sharedInstance].password =  self.passwordTextField.text;
                [[UserAccount sharedInstance] setUser: user];
            
                [self dismissViewControllerAnimated:YES completion:^{
                    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [app save];
                }];
                
            }
        }];

    
}


- (IBAction)loginToTwitter:(id)sender{
   
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [_accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [_accountStore accountsWithAccountType:accountType];
            if (accounts.count) {
                ACAccount *twitterAccount = [accounts lastObject];
                [UserAccount sharedInstance].provider = @"Twitter";
                [UserAccount sharedInstance].provider_uid = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
                [self performSelectorOnMainThread:@selector(postData) withObject:nil waitUntilDone:YES];
                NSLog(@"%@",  [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"]);
               
                
                
                
            }
            else
            {
                [self performSelectorOnMainThread:@selector(showTwitterError:)
                                       withObject:@"Please log into Twitter in the Settings please, then try again!" waitUntilDone:YES];
            }
            
        } else {
            
            [self performSelectorOnMainThread:@selector(showError:)
                                     withObject:@"The user does not grant us permission to access its Twitter account(s). Please turn on Twitter access for Watch AFL in Settings > Privacy > Twitter." waitUntilDone:YES];
             
           
            NSLog(@"The user does not grant us permission to access its Twitter account(s).");
        }
    }];
    
}

- (IBAction)signup:(id)sender{
    

    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegistrationViewController *vc = (RegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
  
    vc.role = [sender tag]?@"agent":@"standard";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)forgottenPassword:(id)sender{
   
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ResetPasswordViewController *vc = (ResetPasswordViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
   
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)close:(id)sender{
    
    [self dismissViewControllerAnimated:NO completion:^{
                
    }];
    
}
/*
- (IBAction)backButtonPressed:(id)sender{
 
 
    WebViewController *vc = (WebViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    vc.url = [NSString stringWithFormat:@"%@auth/register",kBaseURL];
    [self.navigationController pushViewController:vc animated:YES];
    
}

*/

- (IBAction)loginToGoogle:(id)sender{
   // [_signIn authenticate]
   [UserAccount sharedInstance].provider = @"Google";
   [_signIn trySilentAuthentication];
}

/*
- (IBAction)LoginAction:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

    if(![self.emailTextField.text length])
    {
        [self showError:NSLocalizedString(@"Please enter your email address.", @"")];
    }
    else if (![self.passwordTextField.text length])
    {
        
      [self showError:NSLocalizedString(@"Please enter password.", @"")];
    }
    else
    {
        if([self validateEmail:self.emailTextField.text])
        {
            [UserAccount sharedInstance].provider = @"";
            [UserAccount sharedInstance].provider_uid= @"";
          
            
            dispatch_async(dispatch_get_main_queue(),^{
                [self showLoading:@"Logging in..."];
                
            });
            
            _requeset = kLogin;
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           
                                           self.emailTextField.text, @"email",
                                           self.passwordTextField.text, @"password",
                                           nil];
            
            
            
            [AppLinkCenter requestWithPath:@"users"
                                 andParams:params
                             andHttpMethod:@"GET"
                               andDelegate:self];
            
            NSLog(@"params %@",params);
            
        }
        else
        {
            [self showError:NSLocalizedString(@"EamilValidataionError", @"")];
            
        }
    }
  
}
*/

- (IBAction)LoginAction:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if(![self.emailTextField.text length])
    {
        [self showError:NSLocalizedString(@"Please enter your email address.", @"")];
    }
    else if (![self.passwordTextField.text length])
    {
        
        [self showError:NSLocalizedString(@"Please enter password.", @"")];
    }
    else
    {
        if([self validateEmail:self.emailTextField.text])
        {
            [UserAccount sharedInstance].provider = @"";
            [UserAccount sharedInstance].provider_uid= @"";
            
            
            dispatch_async(dispatch_get_main_queue(),^{
                [self showLoading:@"Logging in..."];
                
            });
            
            _requeset = kLogin;
            NSLog(@"Login %@, %@",self.emailTextField.text,self.passwordTextField.text);
            [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text
                                            block:^(PFUser *user, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(),^{
                                                
                                                    [SVProgressHUD dismiss];
                                                    
                                                    
                                                });
                                                if(!error)
                                                {
                                                    if (user) {
                                                        // Do stuff after successful login.
                                                        [UserAccount sharedInstance].password =
                                                        _emailTextField.text;
                                                        [UserAccount sharedInstance].loggedin = YES;
                                                        [[UserAccount sharedInstance] setUser:user];
                                                        PFUser *currentUser = [PFUser currentUser];
                                                        if (currentUser) {
                                                            //save the installation
                                                            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                                            currentInstallation[@"user"] = [[PFUser currentUser]objectId];
                                                        }
                                                       
                                                        
                                                        [self dismissViewControllerAnimated:NO completion:^{
                                                            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                                            [app save];
                                                        }];
                                                    }
                                                }
                                                else
                                                {
                                                    NSString *errorString = [error userInfo][@"error"];
                                                    [[[UIAlertView alloc] initWithTitle:@""
                                                                                message:errorString
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil]
                                                     show];

                                                }
                                              
                                            }];
            
        }
        else
        {
            [self showError:NSLocalizedString(@"EamilValidataionError", @"")];
            
        }
    }
    
}

-(void)showTwitterError:(NSString*)msg
{
    
    [[[UIAlertView alloc] initWithTitle:@"Twitter Authorisation"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}



////////////////////////////////////////////////////////////////////////////////
// RequestDelegate


- (void)request:(AppLinkCenter *)request didReceiveResponse:(NSURLResponse *)response {
    
}


- (void)request:(AppLinkCenter *)request didLoad:(id)result {
    
    NSLog(@"request didLoad %@",result);
    int success = 0;
    dispatch_async(dispatch_get_main_queue(),^{
        [self.hud hide:YES];
        
    });
    
  
    
    if (result != NULL) {
        NSDictionary * results = (NSDictionary*)result;
    
       
        //if(_requeset == kLogin)
        {
        
            if([[results objectForKey:@"status"] integerValue ] == 404)
            {
                
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"ErrorCode_404", @"")
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil]
                 show];

            }
            else if([[results objectForKey:@"status"] integerValue ] == 401)
            {
                
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"ErrorCode_401", @"")
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil]
                 show];
            }
            else  if([[results objectForKey:@"status"] integerValue ] == 200)
            {
                
                NSDictionary * result = [results objectForKey:@"result"];
                //[[UserAccount sharedInstance] setValue:result];

                success = 1;
            }
        }
        
     
    }
    else
    {
        [self showError:@"Please try again"];
    }
    
    
    if(success )
    {
     
        
        [UserAccount sharedInstance].loggedin = YES;
        
        NSLog(@"userid %@",[UserAccount sharedInstance].userid );
        [self dismissViewControllerAnimated:NO completion:^{
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app save];
        }];
    }
    
};

- (void)request:(AppLinkCenter *)request didFailWithError:(NSError *)error {
    

    //[self hidePopup];
    [self showError:[error localizedDescription]];
    NSLog(@"didFailWithError %@" , [error localizedDescription]);
};


#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"loginViewShowingLoggedInUser");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

    //NSLog(@"%@, %@",user.id,user.first_name);
    
    NSLog(@"accessToken %@", FBSession.activeSession.accessTokenData.accessToken);
    [UserAccount sharedInstance].email =[user objectForKey:@"email"];
    [UserAccount sharedInstance].firstname =user.first_name;
    [UserAccount sharedInstance].lastname =user.last_name;
    [UserAccount sharedInstance].provider_uid = [user objectForKey:@"id"];
    [UserAccount sharedInstance].accessToken = FBSession.activeSession.accessTokenData.accessToken;
    [UserAccount sharedInstance].provider = @"Facebook";
    
    NSLog(@"provider_uid %@",   [UserAccount sharedInstance].provider_uid);
    
    //if([[UserAccount sharedInstance].provider isEqualToString:@"Facebook"])
    {
        //if([[UserAccount sharedInstance].provider isEqualToString:@"Facebook"])
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            [FBSession.activeSession close];
            [FBSession setActiveSession:nil];
        }
      
        [self postData];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
//#ifdef DEBUG
//    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
//#endif
//    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
//    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

#pragma mark - GPPSignInDelegate
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    
    NSString *accessTocken = [auth.parameters valueForKey:@"access_token"];
    
    [UserAccount sharedInstance].accessToken = accessTocken;
    NSString *str = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",accessTocken];
    NSString* escapedUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(kBgQueue, ^{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:escapedUrl]];
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         NSError *error;
                                         NSDictionary *user=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                         NSLog(@"user %@",user );
                                         NSLog(@"user %@",[user valueForKey:@"id"] );
                                         
                                         if([user valueForKey:@"id"]!= nil)
                                         {
                                             [UserAccount sharedInstance].provider = @"Google";
                                             
                                             [UserAccount sharedInstance].provider_uid =
                                             [user valueForKey:@"id"] ;
                                             [UserAccount sharedInstance].email =
                                             [user valueForKey:@"email"] ;
                                             [UserAccount sharedInstance].firstname =
                                             [user valueForKey:@"given_name"] ;
                                             [UserAccount sharedInstance].lastname =
                                             [user valueForKey:@"family_name"] ;
                                             [self refreshInterfaceBasedOnSignIn];
                                         }
                                         else
                                         {
                                              //[self showError:@"Please try again"];
                                         }
                });
                                     });

        
    NSLog(@"Received error %@ and auth object %@",error, auth);
}

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        [[GPPSignIn sharedInstance] disconnect];
    } else {
    }
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}
- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
     
    } else {
          [self performSelectorOnMainThread:@selector(postData) withObject:nil waitUntilDone:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [[event allTouches] anyObject];
	
	
	if ([touch view] == self.view)
	{
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
	}
    
   
	
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    RegistrationViewController *vc = (RegistrationViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    
    vc.role = @"standard";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
