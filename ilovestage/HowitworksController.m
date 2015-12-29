//
//  MyDetailsViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "HowitworksController.h"
#import "SWRevealViewController.h"
@interface HowitworksController ()

@end

@implementation HowitworksController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
     self.view.backgroundColor = UIColorFromRGB(0x111111);
   
    self.title = NSLocalizedString(@"HOW IT WORKS", @"HOW IT WORKS");
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
//    if([ [ UIScreen mainScreen ] bounds ].size.height == 568)
//    {
//        
//    }
//    else{
//        [self.view setFrame:CGRectMake(0, 100, 320, self.view.frame.size.height)];
//    }
    
   

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,20 ,320-20, 50)];
    label.font =  [UIFont fontWithName:@"Seravek" size:18];
    label.textColor =  UIColorFromRGB(0xf3f3f3);
    label.textAlignment = UITextAlignmentCenter;
    label.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    label.text  = @"ILOVESTAGE app allows you \nto find the best available seats \nat affordable group-rate prices for the top 10 West End shows by grouping your booking with others.";
    [_scrollview addSubview:label];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setNumberOfLines:0];
    [label sizeToFit];
    
  
    
    
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20,9999);
    
    CGSize expectedLabelSize = [label.text sizeWithFont: label.font
                                      constrainedToSize:maximumLabelSize
                                          lineBreakMode:label.lineBreakMode];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake((320-250)/2,
                                                            label.frame.origin.y + label.frame.size.height+20,
                                                            250,
                                                            1)];
    line.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:line];
    
    [_scrollview setContentSize:CGSizeMake(320, self.view.frame.size.height)];
    UILabel *step1 = [[UILabel alloc] initWithFrame:CGRectMake(20,line.frame.origin.y + 20 ,320-40, 25)];
    step1.font =  [UIFont fontWithName:@"Seravek-Bold" size:18];
    step1.textColor =  UIColorFromRGB(0xf3f3f3);
    step1.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    step1.text  = @"STEP 1";
    step1.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:step1];
    
    UILabel *des1 = [[UILabel alloc] initWithFrame:CGRectMake(20,step1.frame.origin.y + 25+ 10 ,320-40, 25)];
    des1.font =  [UIFont fontWithName:@"Seravek" size:16];
    des1.textColor =  UIColorFromRGB(0xf3f3f3);

    des1.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    des1.text  = @"Browse the most booked tickets of the Top 10 Theatre Shows or search directly for a show of your choice.";
    des1.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:des1];
    [des1 setLineBreakMode:UILineBreakModeWordWrap];
    [des1 setNumberOfLines:0];
    [des1 sizeToFit];
    
    UIView* line2 = [[UIView alloc] initWithFrame:CGRectMake((320-250)/2,
                                                            des1.frame.origin.y + des1.frame.size.height+20,
                                                            250,
                                                            1)];
    line2.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:line2];
    
    
    UILabel *step2 = [[UILabel alloc] initWithFrame:CGRectMake(20,line2.frame.origin.y + 20 ,320-40, 25)];
    step2.font =  [UIFont fontWithName:@"Seravek-Bold" size:18];
    step2.textColor =  UIColorFromRGB(0xf3f3f3);
    step2.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    step2.text  = @"STEP 2";
    step2.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:step2];
    
    UILabel *des2 = [[UILabel alloc] initWithFrame:CGRectMake(20,step2.frame.origin.y + 25+ 10 ,320-40, 25)];
    des2.font =  [UIFont fontWithName:@"Seravek" size:16];
    des2.textColor =  UIColorFromRGB(0xf3f3f3);
    des2.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    des2.text  = @"Join an existing group. Or start one for your show and other users will join. \nYour group rate tickets will be available once we have ten or more signed up for your chosen show time. \n\nPlease note however, that the booking can be cancelled if this minimum number is not met. You are still eligible to purchase single tickets at ILOVESTAGE's discounted rate which is slightly higher than the group rate but nevertheless lower than standard ticket prices";
    des2.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:des2];
    [des2 setLineBreakMode:UILineBreakModeWordWrap];
    [des2 setNumberOfLines:0];
    [des2 sizeToFit];
    
    UIView* line3 = [[UIView alloc] initWithFrame:CGRectMake((320-250)/2,
                                                             des2.frame.origin.y + des2.frame.size.height+20,
                                                             250,
                                                             1)];
    line3.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:line3];

    UILabel *step3 = [[UILabel alloc] initWithFrame:CGRectMake(20,line3.frame.origin.y + 20 ,320-40, 25)];
    step3.font =  [UIFont fontWithName:@"Seravek-Bold" size:18];
    step3.textColor =  UIColorFromRGB(0xf3f3f3);
    step3.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    step3.text  = @"STEP 3";
    step3.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:step3];
    
    UILabel *des3 = [[UILabel alloc] initWithFrame:CGRectMake(20,step3.frame.origin.y + 25+ 10 ,320-40, 25)];
    des3.font =  [UIFont fontWithName:@"Seravek" size:16];
    des3.textColor =  UIColorFromRGB(0xf3f3f3);
    des3.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    des3.text  = @"Pick up your tickets in person \nat ILOVESTAGE ticket office.";
    des3.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:des3];
    [des3 setLineBreakMode:UILineBreakModeWordWrap];
    [des3 setNumberOfLines:0];
    [des3 sizeToFit];
    des3.frame = CGRectMake(20,step3.frame.origin.y + 25+ 10 ,320-40, des3.frame.size.height);
    
    
    UIView* line4 = [[UIView alloc] initWithFrame:CGRectMake((320-250)/2,
                                                             des3.frame.origin.y + des3.frame.size.height+20,
                                                             250,
                                                             1)];
    line4.backgroundColor = [UIColor whiteColor];
    [_scrollview addSubview:line4];

    
    UILabel *step4= [[UILabel alloc] initWithFrame:CGRectMake(20,line4.frame.origin.y + 20 ,320-40, 25)];
    step4.font =  [UIFont fontWithName:@"Seravek-Bold" size:18];
    step4.textColor =  UIColorFromRGB(0xf3f3f3);
    step4.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    step4.text  = @"STEP 4";
    step4.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:step4];
    /*
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20,step4.frame.origin.y + 25+ 10 ,320-40, 120)];
    textView.font =  [UIFont fontWithName:@"Seravek" size:16];
    textView.text = NSLocalizedString(@"CUSTOMER SUPPORT MSG", @"");
    textView.text = @"Enjoy up to 20% off at restaurants, gift shops and our many other partners.\n\nTo take advantage of this special offer, get your coupon codes from www.ilovesetage.co.uk.";
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.tintColor = UIColorFromRGB(0x3491ed);
    textView.textColor =  UIColorFromRGB(0xf3f3f3);
    textView.textContainer.lineFragmentPadding = 0;
    textView.backgroundColor = [UIColor clearColor];
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.delegate = self;

    [_scrollview addSubview:textView];*/
    
    UILabel *des4 = [[UILabel alloc] initWithFrame:CGRectMake(20,step4.frame.origin.y + 25+ 10 ,320-40, 25)];
    des4.font =  [UIFont fontWithName:@"Seravek" size:16];
    des4.textColor =  UIColorFromRGB(0xf3f3f3);
    des4.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
    des4.text  = @"Enjoy up to 20% off at restaurants, gift shops and our many other partners.\n\nTo take advantage of this special offer, get your coupon codes from ILOVESTAGE.";
    des4.textAlignment = UITextAlignmentCenter;
    [_scrollview addSubview:des4];
    [des4 setLineBreakMode:UILineBreakModeWordWrap];
    [des4 setNumberOfLines:0];
    [des4 sizeToFit];
    des4.frame = CGRectMake(20,step4.frame.origin.y + 25+ 10 ,320-40, des4.frame.size.height);
    

    [_scrollview setContentSize:CGSizeMake(320, 1200)];

}

- (CGFloat)topOfViewOffset
{
    CGFloat top = 0;
    if ([self respondsToSelector:@selector(topLayoutGuide)])
    {
        top = self.topLayoutGuide.length;
    }
    return top;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
    return YES;
}


@end
