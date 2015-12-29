//
//  AboutViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "AboutViewController.h"

#import "HelpViewController.h"
#import "AboutDetailsViewController.h"
#import "HelpContentViewController.h"
#import "SWRevealViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
  
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    //self.view.backgroundColor = UIColorFromRGB(0x111111);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-navigation"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"ABOUT";
    //[Global sharedInstance].curMenu = ABOUT;
    

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showTermsOfUse:(id)sender
{
    
//    WebViewController *vc = (WebViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    vc.url = [NSString stringWithFormat:@"%@help/terms",kBaseURL];
//    [self.navigationController pushViewController:vc animated:NO];
    AboutDetailsViewController *vc = (AboutDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AboutDetailsViewController"];
    vc.mode = TERMS_OF_USE;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)faq:(id)sender{
    
//        HelpContentViewController *vc = (HelpContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpContentViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
//        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: NO];
 
}

-(IBAction)showPrivacy:(id)sender
{
    AboutDetailsViewController *vc = (AboutDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AboutDetailsViewController"];
    vc.mode = PRIVACY_POLICY;
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    NSString*msg = [NSString stringWithFormat:@"I accept the Site Terms and Conditions and understand that personal information I provide will be used by Rightster in accordance with the Rightster Privacy Policy available at %@help/privacypolicy and may be disclosed by Rightster to the AFL, AFL Clubs and AFL 3rd parties for use in accordance with the AFL’s Privacy Policy available at www.afl.com.au/privacy.",kBaseURL];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Policy" message:msg
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go to Watch AFL Privacy Policy",@"Go to AFL Privacy Policy", nil];
    alert.tag = PRIVACY_POLICY;
    [alert show];
    */
    

}

-(IBAction)aboutus:(id)sender
{
    
    AboutDetailsViewController *vc = (AboutDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AboutDetailsViewController"];
    vc.mode = ABOUT_US;
    [self.navigationController pushViewController:vc animated:YES];
    //[self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: NO];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == TERMS_OF_USE)
    {
        if (buttonIndex == 1)
        {
            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebViewController *vc = (WebViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            vc.url = [NSString stringWithFormat:@"%@help/terms",kBaseURL];
            [self.navigationController pushViewController:vc animated:NO];
            
        }
    }
    else if(alertView.tag == PRIVACY_POLICY)
    {
        WebViewController *vc = (WebViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        
        if (buttonIndex == 1)
        {
            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            vc.url = [NSString stringWithFormat:@"%@help/privacypolicy",kBaseURL];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if (buttonIndex == 2)
        {
            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            vc.url = @"http://www.afl.com.au/privacy";
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
}

@end
