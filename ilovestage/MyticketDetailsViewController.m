//
//  MyticketDetailsViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 15/10/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "MyticketDetailsViewController.h"
#import "MapViewController.h"

@interface MyticketDetailsViewController ()
@property (strong, nonatomic)  NSMutableArray *coupons;
@property (strong, nonatomic)  NSMutableArray *buttonArray;

@property (nonatomic, strong) MapViewController *mapViewController;
@end

@implementation MyticketDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getTestEvent
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shows" ofType:@"plist"];
    NSMutableArray* _events = [[NSMutableArray alloc] initWithContentsOfFile:path];
    _show =  [[_events objectAtIndex:0] mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //_scrollview.backgroundColor = UIColorFromRGB(0x3491ed);
    UIFont* font =  [UIFont fontWithName:@"Seravek" size:16];
    
    _name.font =  font;
    _totalpaid.font =  font;
    _numoftickets.font =  font;
    _bookingnumber.font =  font;
    _showname.font = font;
    _date.font =  font;
    _venue.font =  font;
    _location.font =  font;
    _ticketType.font =  font;
    
    _bookingdetails.font =  [UIFont fontWithName:@"Seravek-Light" size:18];
    _ticketcollection.font =  [UIFont fontWithName:@"Seravek-Light" size:18];
    _specialoffers.font =  [UIFont fontWithName:@"Seravek-Light" size:18];
    
    _offers.font =  [UIFont fontWithName:@"Seravek-Light" size:16];
    _ticketoffice.font =  [UIFont fontWithName:@"Seravek" size:16];
    _section.frame = CGRectMake(0, 20, self.view.frame.size.width, _section.frame.size.height) ;
   
    self.title = @"MY TICKET";
    
    //[self getTestEvent];
 
    
    _mapViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"MapViewControllerID"];
    _mapViewController.type = 0;
    _mapViewController.show = _show;
 
    
    
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20,9999);
    
    CGSize expectedLabelSize = [_bookingdetails.text sizeWithFont: _bookingdetails.font
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:_bookingdetails.lineBreakMode];
    
    UIView* line1 = [[UIView alloc] initWithFrame:CGRectMake(_bookingdetails.frame.origin.x,
                                                            _bookingdetails.frame.origin.y + 38,
                                                            expectedLabelSize.width,
                                                            1)];
    line1.backgroundColor = [UIColor blackColor];
    [_section addSubview:line1];
    
   
    //_bookingdetails.backgroundColor = UIColorFromRGB(0x3491ed);

    
    expectedLabelSize = [_ticketcollection.text sizeWithFont: _ticketcollection.font
                                         constrainedToSize:maximumLabelSize
                                             lineBreakMode:_ticketcollection.lineBreakMode];
    
    UIView* line2 = [[UIView alloc] initWithFrame:CGRectMake(_ticketcollection.frame.origin.x,
                                                             _ticketcollection.frame.origin.y + 38,
                                                             expectedLabelSize.width,
                                                             1)];
    line2.backgroundColor = [UIColor blackColor];
    [_section addSubview:line2];
    
    expectedLabelSize = [_specialoffers.text sizeWithFont: _specialoffers.font
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:_specialoffers.lineBreakMode];
    
    UIView* line3 = [[UIView alloc] initWithFrame:CGRectMake(_specialoffers.frame.origin.x,
                                                             _specialoffers.frame.origin.y + 38,
                                                             expectedLabelSize.width,
                                                             1)];
    line3.backgroundColor = [UIColor blackColor];
    [_section addSubview:line3];

    _notes = [[UILabel alloc] initWithFrame:CGRectMake(10,_ticketcollection.frame.origin.y + _ticketcollection.frame.size.height ,self.view.frame.size.width-20, 20)];
    _notes.font =  [UIFont fontWithName:@"Seravek-Light" size:16];
    _notes.textColor = [UIColor blackColor];
    _notes.text =   NSLocalizedString(@"TICKET COLLECTION", @"");
  
    [_section addSubview:_notes];
    [_notes setLineBreakMode:UILineBreakModeWordWrap];
    [_notes setNumberOfLines:0];
    [_notes sizeToFit];
  
    _ticketoffice.text = @"4th Floor, Rex House,\n4-12Regent Street,\nLondon, SW1Y 4RG";
    
//    _offers.text = NSLocalizedString(@"OFFER", @"");
//    _offers.lineBreakMode = NSLineBreakByWordWrapping;
//    _offers.numberOfLines = 0;
//    [_offers sizeToFit];
    [self.scrollview addSubview:_section];
    
    _coupons = [NSMutableArray new];
    _buttonArray =[NSMutableArray new];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    _name.text = [UserAccount sharedInstance].firstname;
    _numoftickets.text =  [NSString stringWithFormat:@"%@"
                           , [_booking objectForKey:@"total"]];
 
    _totalpaid.text =  [NSString stringWithFormat:@"£ %.2f"
                        ,[[_show objectForKey:@"group_discountprice"] floatValue ]*
                        [_numoftickets.text integerValue]];
    //NSString *trimmedString=[[_event objectForKey:@"_id"] substringFromIndex:MAX((int)[[_event objectForKey:@"_id"] length]-8, 0)];
    
    _bookingnumber.text = _booking.objectId;
    
    _ticketType.text = [_show objectForKey:@"priceband"];
    _showname.text = [_show objectForKey:@"name"];
    _venue.text = [_show objectForKey:@"theatre"];
    _location.text = [_show objectForKey:@"location"];
    
    NSDateFormatter* formatter = nil;
    if (formatter == nil)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
         [formatter setDateFormat:@"dd MM yyyy"];
    }

    NSDate* date = [formatter dateFromString:[_booking objectForKey:@"date"]];
    
    if([[UserAccount sharedInstance].language isEqualToString:@"ko"])
       [formatter setDateFormat:@"MMM dd일"];
    else
        [formatter setDateFormat:@"EEEE, d MMM"];
   
    NSString *dateString = [formatter stringFromDate:date];
    _date.text = [NSString stringWithFormat:@"%@ %@",dateString,[_booking objectForKey:@"time"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) initUI
{
    
    UITextView *offers = [[UITextView alloc] initWithFrame:
                          CGRectMake(_offers.frame.origin.x,_offers.frame.origin.y +10
                                    ,_offers.frame.size.width,_offers.frame.size.height)];
    offers.font =  [UIFont fontWithName:@"Seravek-Light" size:16];
    offers.text =  NSLocalizedString(@"OFFER", @"");
    
    offers.scrollEnabled = NO;
    offers.editable = NO;
    offers.dataDetectorTypes = UIDataDetectorTypeLink;
    offers.textColor = [UIColor blackColor];
    offers.textContainer.lineFragmentPadding = 0;
    offers.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    offers.delegate = self;
    
    [_scrollview addSubview:offers];
    int y = _offers.frame.origin.y +_offers.frame.size.height;
    /*
    int y = 0;
    for (int i =0; i< 4;i++)
    {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:
                                  CGRectMake(10 ,_offers.frame.origin.y +
                                             _offers.frame.size.height + 25 +5+ i*63 + i*10 ,225,63)];
        imageview.contentMode =UIViewContentModeScaleToFill;
        
        
        imageview.image = [UIImage imageNamed:@"ticket_background"];
        
        [_scrollview addSubview:imageview];
      

        
        
        UIImage * logo = nil;
        //logo = [UIImage imageNamed:@"coupon_kimchi"];
        //logo = [UIImage imageNamed:@"coupon_wasabi"];
        if(i == 0)
             logo = [UIImage imageNamed:@"kimchi"];
        else if(i == 1)
            logo = [UIImage imageNamed:@"wasabi"];
        else if(i == 2)
            logo = [UIImage imageNamed:@"kyoto"];
        else if(i == 3)
           logo = [UIImage imageNamed:@"coolbritannia"];
        else if(i == 4)
            logo = [UIImage imageNamed:@"eurobike"];
        
        //UIImageView *logoView = [[UIImageView alloc] initWithFrame:
        //                          CGRectMake(imageview.frame.size.width -5 - logo.size.width/2,(63 - (logo.size.height/2))/2,logo.size.width/2,logo.size.height/2)];
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:
                                 CGRectMake(imageview.frame.size.width -70,0,70,62)];
        logoView.image = logo;
      
        logoView.backgroundColor = [UIColor clearColor];
        [imageview addSubview:logoView];
        

        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45,10 ,125, 15)];
        title.font =  [UIFont fontWithName:@"Seravek-Bold" size:14];
        title.textColor = [UIColor blackColor];
        title.text = @"20% OFF";
        [title setLineBreakMode:UILineBreakModeWordWrap];
        [title setNumberOfLines:0];
        [title sizeToFit];
        [imageview addSubview:title];
        
        UILabel *place = [[UILabel alloc] initWithFrame:CGRectMake(45,title.frame.origin.y + title.frame.size.height +5 ,125, 15)];
        place.font =  [UIFont fontWithName:@"Seravek" size:12];
        place.textColor = [UIColor blackColor];
        //UIColorFromRGB(0x3491ed);
        place.text = @"KIMCHEE";
        
        if(i == 1)
            place.text = @"WASABI";
        if(i == 2)
            place.text = @"KYOTO";
        if(i == 3)
            place.text = @"BRITANNIA";
        if(i == 4)
            place.text = @"자전거 나라";
        [place setLineBreakMode:UILineBreakModeWordWrap];
        [place setNumberOfLines:0];
        [place sizeToFit];
        [imageview addSubview:place];
       
        UILabel *ref = [[UILabel alloc] initWithFrame:CGRectMake(-7 ,20 ,63, 25 )];
        ref.font =  [UIFont fontWithName:@"Seravek-Light" size:8];
        ref.backgroundColor = [UIColor clearColor];
        ref.textAlignment = NSTextAlignmentCenter;
        ref.textColor = [UIColor blackColor];
        //UIColorFromRGB(0x3491ed);
        ref.text = @"1234567890";
    
        ref.transform = CGAffineTransformMakeRotation(-(M_PI)/2);
        //[ref.layer setAnchorPoint:CGPointMake(0.0, 1.0)];
        [imageview addSubview:ref];
        y =imageview.frame.origin.y + imageview.frame.size.height;
        
        UIButton *usenow = [UIButton buttonWithType:UIButtonTypeSystem];
        usenow.frame = CGRectMake(imageview.frame.origin.x + 225 +10, imageview.frame.origin.y+ 20, 126/2, 48/2);
        usenow.tag = i;
        usenow.tintColor = [UIColor whiteColor];
        [usenow addTarget:self action:@selector(useCoupon:) forControlEvents:UIControlEventTouchUpInside];
        usenow.titleLabel.font =  [UIFont fontWithName:@"Seravek-Bold" size:14];
        [usenow setTitle:@"USENOW" forState:UIControlStateNormal];
        [usenow setBackgroundImage:[UIImage imageNamed:@"usenow"] forState:UIControlStateNormal];
        [_coupons addObject:usenow];
        [_scrollview addSubview:usenow];
        
        UIButton *used = [UIButton buttonWithType:UIButtonTypeSystem];
        used.frame = CGRectMake( (225 -86)/2 + 40,  30, 86/2, 48/2);
        used.tag = i;
        used.tintColor = [UIColor redColor];
       
        used.titleLabel.font =  [UIFont fontWithName:@"Seravek-Bold" size:14];
        [used setTitle:@"USED" forState:UIControlStateNormal];
        [used setBackgroundImage:[UIImage imageNamed:@"used"] forState:UIControlStateNormal];
        used.hidden = YES;
        [_buttonArray addObject:used];
        [imageview addSubview:used];
        
        
    }
    */
    
    UILabel *help = [[UILabel alloc] initWithFrame:CGRectMake(10,y +20 ,200, 50)];
    help.font =  [UIFont fontWithName:@"Seravek-Light" size:18];
    help.textColor = [UIColor blackColor];
    help.text =  NSLocalizedString(@"CUSTOMER SUPPORT", @"");
   
    [_scrollview addSubview:help];
    
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20,9999);
    
    CGSize expectedLabelSize = [help.text sizeWithFont: help.font
                                                constrainedToSize:maximumLabelSize
                                                    lineBreakMode:help.lineBreakMode];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(help.frame.origin.x,
                                                             help.frame.origin.y + 38,
                                                             expectedLabelSize.width,
                                                             1)];
    line.backgroundColor = [UIColor blackColor];
    [_scrollview addSubview:line];
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, y  + help.frame.size.height +10, self.view.frame.size.width -20, 150)];
    textView.font =  [UIFont fontWithName:@"Seravek-Light" size:16];
    textView.text = NSLocalizedString(@"CUSTOMER SUPPORT MSG", @"");
    
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    textView.textColor = [UIColor blackColor];
    textView.textContainer.lineFragmentPadding = 0;
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
   
    
    textView.delegate = self;
    [_scrollview addSubview:textView];
    
    
    
    [_scrollview setContentSize:CGSizeMake(self.view.frame.size.width, y + 300)];
    UIImageView * logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_120"]];
    logo.frame =CGRectMake((self.view.frame.size.width-60)/2, _scrollview.contentSize.height -40- 60, 60, 60);
    [_scrollview addSubview:logo];
    
    [self.view bringSubviewToFront:logo];
    
    
    
}

-(IBAction)useCoupon:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to use this coupon?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = [sender tag];
    [alert show];
}


-(IBAction)viewMap:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _mapViewController.type = (int)[sender tag];
    [app.window addSubview:_mapViewController.view];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
    return YES;
}


#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIButton* usenow = [_coupons objectAtIndex:[alertView tag]];
    usenow.hidden = YES;
    
    UIButton* used = [_buttonArray objectAtIndex:[alertView tag]];
    used.hidden = NO;
}
@end
