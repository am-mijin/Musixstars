//
//  BaseViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>


@interface BaseViewController (private)

@end

@implementation BaseViewController

@synthesize status;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(id)init
{
	self = [super init];
	
	if (self)
	{
		//not on by default
	}
	
	return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
   
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       
        //[[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"top-navigation-logo"] forBarMetrics:UIBarMetricsDefault];
       
    }
    else {
    
        [self.navigationController.navigationBar setTitleTextAttributes:    [NSDictionary dictionaryWithObjectsAndKeys:
                                                                             [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                             [UIFont fontWithName:@"GothamRounded-Bold" size:18.0], NSFontAttributeName, nil]];
        if([Global sharedInstance].curMenu == FEEDS)
        {
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-navigation-logo"] forBarMetrics:UIBarMetricsDefault];
            
        }
        else
        {
           [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-navigation"] forBarMetrics:UIBarMetricsDefault];

        }
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
//     self.navigationController.navigationBar.topItem.title = @"";
   
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"custom_up_indicator.png"]];
//
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"custom_up_indicator.png"]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor  whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{  
    [super viewWillDisappear:animated];
    dispatch_async(dispatch_get_main_queue(),^{
        
        [SVProgressHUD dismiss];
        
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setupTitleLabel];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

  
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) showLoading:(NSString*)msg
{
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:255/255.0 green:223/255.0 blue:0/255.0 alpha:1.0]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithRed:255/255.0 green:78/255.0 blue:134/255.0 alpha:1.0]];
    [SVProgressHUD setRingThickness:5];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 27)];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD show];
    });
    
    
    
    //_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     /*
    if( _hud.customView  == nil)
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_01"]];
    
    _hud.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    _hud.color = [UIColor colorWithRed:52.0/255.0 green:145.0/255.0 blue:237.0/255.0 alpha:0.90];

    // Set custom view mode
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = msg;
     */
    
  

}

-(void)hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    
    //[NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[self showBusyView:NO animated:YES msg:@""];
    //[_hud hide:YES];
    
}

-(IBAction)backButtonPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];		
}

//
//-(void)setupBackButton {
//
//	self.navigationItem.hidesBackButton = YES;
//	
//	UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
//	backView.backgroundColor = [UIColor clearColor];
//	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//	button.frame = CGRectMake(0, 0, 50.0, 29);
//	backView.frame = button.frame;
//	[button setBackgroundImage:[UIImage imageNamed:@"custom_up_indicator"] forState:UIControlStateNormal];
//	[button setBackgroundImage:[UIImage imageNamed:@"custom_up_indicator"] forState:UIControlStateHighlighted];
//	[button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//	
//	[backView addSubview:button];
//	
//	self.backButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
//	[self.navigationItem setLeftBarButtonItem:self.backButton];
//	
//}

/*
- (UIButton *)imageButton:(CGRect)frame:(NSString*)buttonBackground:(NSString*)buttonBackgroundPressed:(int)tag
{	
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:buttonBackground] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:buttonBackgroundPressed] forState:UIControlStateHighlighted];
    //[button addTarget:self action:@selector(addToDiary) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
   
	return button;
}
*/

- (UILabel *) newLabelWithPrimaryColor: (UIColor *) primaryColor selectedColor: (UIColor *) selectedColor fontSize: (CGFloat)fontSize bold: (BOOL)bold
{
	
	 //Create and configure a label.
	 UIFont *font;
	 if (bold) {
	 font = [UIFont boldSystemFontOfSize:fontSize];
	 } else {
	 font = [UIFont systemFontOfSize:fontSize];
	 }

    
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
    newLabel.font = font;
	//newLabel.font = [UIFont fontWithName:@"AppleGothic" size:fontSize];
	return newLabel;
}

/*
-(void)setupTitleLabel {
   
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 44)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.adjustsFontSizeToFitWidth = YES;
	//self.titleLabel.minimumFontSize = 10;
	//self.titleLabel.textAlignment = UITextAlignmentCenter;
	self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    //self.titleLabel.font = [UIFont fontWithName:@"Bariol_Bold" size:22];
    
	self.titleLabel.text = self.title;
	self.titleLabel.textColor = [UIColor colorWithRed:245/255.0 green:60/255.0 blue:17/255.0 alpha:1];
    self.titleLabel.shadowColor = [UIColor whiteColor];
	self.titleLabel.shadowOffset = CGSizeMake(+1, +1);
   
	self.navigationItem.titleView = self.titleLabel;
}
*/

- (NSString *)displayStringForDouble:(double)aDouble
{
    if (isnan(aDouble))
    {
        return @"N/A";
    }
    else
    {
        return [NSString stringWithFormat:@"%f", aDouble];
    }
}

- (NSString *)URLEncodingOfString:(NSString *)s
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) s,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8));
	return escapedString;
}

-(NSString *) updatedDate:(NSDate*)lastDate
{
    
    NSDate *todaysDate =[NSDate date];
    
    NSTimeInterval epoch = [todaysDate timeIntervalSinceDate:lastDate];
    
    
    //int sec = (int)epoch % 60;
    //epoch -= sec;
    
    int minSeconds = (int)epoch % 3600;
    //epoch -= minSeconds;
    int min = (minSeconds / 60);
    
    int hourSeconds = (int)epoch % 86400;
    //epoch -= hourSeconds;
    int hour = (hourSeconds / 3600);
    
    int daySeconds = (int)epoch % 604800;
    //epoch -= daySeconds;
    int day = (daySeconds / 86400);
    
	int weekSeconds = (int)epoch % 2419200;
	//epoch -= weekSeconds;
    int week = (weekSeconds / 604800);
    
	int monthSeconds = (int)epoch % 29030400;
	//epoch -= monthSeconds;
    int month = (monthSeconds / 2419200);
    
	int year = (epoch / 29030400);
    
    
    //--------------------------------------------------
    // Text
    
    NSString * singleOutput;
    
    
    
	if (year > 0) {
		singleOutput = [NSString stringWithFormat:@"%d year%@ ago" ,  year , (
                                                                              year != 1 ? @"s" : @"")];
	}
	else if (month > 0) {
		singleOutput = [NSString stringWithFormat:@"%d month%@ ago" ,  month , (
                                                                                month != 1 ? @"s" : @"")];
	}
    else if (week > 0) {
        singleOutput = [NSString stringWithFormat:@"%d week%@ ago" ,  week , (
                                                                              week != 1 ? @"s" : @"")];
    }
    else if (day > 0) {
        singleOutput = [NSString stringWithFormat:@"%d day%@ ago" ,  day , ( day
                                                                            != 1 ? @"s" : @"")];
    }
    else if (hour > 0) {
        singleOutput = [NSString stringWithFormat:@"%d hour%@ ago" ,  hour , (
                                                                              hour != 1 ? @"s" : @"")];
    }
    else if (min > 0) {
        singleOutput = [NSString stringWithFormat:@"%d min%@ ago" ,  min , ( min
                                                                        != 1 ? @"s" : @"")];
    }
    else {
        
        if(min < 1)
        {
            singleOutput = @"Less than a minute ago";

        }
        else
        {
          //  singleOutput = [NSString stringWithFormat:@"%d sec%@ ago" ,  sec , ( sec
          //                                                              != 1 ? @"s" : @"")];
        }
    }
    return singleOutput;
}

-(BOOL)shouldAutorotate
{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            return YES;
       }
       else {
           return NO;
        }
}

- (NSUInteger)supportedInterfaceOrientations {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskLandscape;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(void)showError:(NSString*)msg
{
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}
@end
