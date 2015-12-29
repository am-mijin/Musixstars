//
//  ResetPasswordViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"";

    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    self.title =NSLocalizedString(@"RESET PASSWORD", @"");
    
	// Do any additional setup after loading the view.
    
    if(TEST)
        self.emailTextField.text = @"ilovestageapp@gmail.com";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)resetPassword:(id)sender
{
    if([self.emailTextField.text length] > 0)
    {
        if([self validateEmail:self.emailTextField.text])
        {
            [self postData];
            
        }
        else
        {
            
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:NSLocalizedString(@"EamilValidataionError", @"")
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil]
             show];
            
        }

    }
    else{
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"Please enter your email address.", @"")
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil]
         show];
    }
    
}

-(void)postData
{
    [self.emailTextField resignFirstResponder];
    //[self URLEncodingOfString:self.emailTextField.text]
    /*
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   
                                  self.emailTextField.text, @"email",
                                   @"password", @"forgot",
                                   
                                   nil];
    
    
    
    [AppLinkCenter requestWithPath:@"users"
                         andParams:params
                     andHttpMethod:@"GET"
                       andDelegate:self];
    
    NSLog(@"params %@",params);
    */
    [PFUser requestPasswordResetForEmailInBackground:self.emailTextField.text];
}

#pragma mark -
#pragma mark === TextField Delegate ===
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resetPassword:nil];
	return YES;
}


////////////////////////////////////////////////////////////////////////////////
// RequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(AppLinkCenter *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(AppLinkCenter *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(AppLinkCenter *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(AppLinkCenter *)request didLoad:(id)result {
    
    NSLog(@"request didLoad %@",result);
    [self.view setUserInteractionEnabled:YES];
    
    int status = 0;
    
    if (result != NULL) {
        NSDictionary * results = (NSDictionary*)result;
        status =[[results objectForKey:@"status"] intValue ];
        
        switch (status) {

            case 100:
                [self showError:NSLocalizedString(@"Unable to reset password!", @"")];
              
                NSLog(@"Unable to reset password!");
                break;
                
            case 200:
                break;
            case 404:
                
                NSLog(@"A user with those credentials does not exist");
                [self showError:NSLocalizedString(@"E-mail not identified!", @"")];
          
                break;
             
        }
        
    }
    else
    {
        //[self showPopup:@"Please try again"];
    }
    
    
    if(status == 200)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"Password reset email has been sent!"
                                                       delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        
        [alert show];

        
    }
};



/**
 * Called when an error prevents the API request from completing
 * successfully.
 */
- (void)request:(AppLinkCenter *)request didFailWithError:(NSError *)error {
    
    [self.view setUserInteractionEnabled:YES];
    //[self hidePopup];
    //[self showError:[error localizedDescription]];
    NSLog(@"FBRequest didFailWithError %@" , [error localizedDescription]);
};

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate
{
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) return NO;
    else return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == self.view)
    {
        [_emailTextField resignFirstResponder];
    }
}
@end
