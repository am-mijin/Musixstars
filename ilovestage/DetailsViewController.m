//
//  DetailsViewController.m
//  ILOVESTAGE
//
//  Created by Mijin Cho on 14/08/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "DetailsViewController.h"
#import "PaymentViewController.h"
#import "SWRevealViewController.h"
#import "MapViewController.h"
#import "BookTicketsViewController.h"
#import "LoginViewController.h"

//#import <KakaoOpenSDK/KakaoOpenSDK.h>
@interface DetailsViewController ()

@property (nonatomic, weak)  IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic, weak) IBOutlet   UIButton *ordernowBtn;

@property (weak, nonatomic) IBOutlet UIView *top;
@property (nonatomic, strong) NSArray *sizes;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableDictionary* product;
@property (nonatomic, strong) UILabel *price;

@property (nonatomic, strong) MapViewController *mapViewController;
@property (readwrite) BOOL play;
@property (readwrite) int percentage;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@property(nonatomic, retain) NSMutableDictionary *kakaoTalkLinkObjects;
@property (nonatomic, strong) MKLocalSearch *localSearch;
@end


@implementation DetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
   
	//[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    
    //_mapViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"MapViewControllerID"];
    //_mapViewController.show = _obj;
    
    
    //[_mapViewController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width,
    //                                             _mapViewController.view.frame.size.height)];
    
    
   
    _scrollview.delegate = self;
    _product = [NSMutableDictionary new];
    _buttons = [NSMutableArray new];
    [self initUI];


    self.view.backgroundColor = [UIColor whiteColor];
    _top.backgroundColor =[UIColor whiteColor];
    _top.alpha = 0;
 
    
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Global sharedInstance].isShowingLandscapeView = YES;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)getYTUrlStr:(NSString*)url
{
    if (url == nil)
        return nil;
    
    NSString *retVal = [url stringByReplacingOccurrencesOfString:@"watch?v=" withString:@"v/"];
    
    NSRange pos=[retVal rangeOfString:@"version"];
    if(pos.location == NSNotFound)
    {
        retVal = [retVal stringByAppendingString:@"?version=3&hl=en_EN"];
    }
    return retVal;
}


/*
- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {
    
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
//    if(_videoView == nil) {
//        _videoView = [[UIWebView alloc] initWithFrame:frame];
//        _videoView.delegate=self;
//        [self.view addSubview:_videoView];
//    }
//    
    
//    _videoView.mediaPlaybackAllowsAirPlay=YES;
//    _videoView.allowsInlineMediaPlayback=YES;
//    [_videoView loadHTMLString:html baseURL:nil];
    
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
- (IBAction) load:(id)sender
{
	[self.videoContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSString* metadata =[_show objectForKey:@"metadata"];
    if([[_show objectForKey:@"reference"] isEqualToString:@"6"])
        metadata = @"GRpWkWY5W0c";
    else if([[_show objectForKey:@"reference"] isEqualToString:@"1"])
        metadata = @"IuEFm84s4oI";
    
	self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:metadata];
	self.videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];

    
    //[self.videoPlayerViewController.moviePlayer prepareToPlay];
    //self.videoPlayerViewController.moviePlayer.shouldAutoplay = NO;
    [self.videoPlayerViewController presentInView:self.videoContainerView];
    _logoview.frame = CGRectMake(0, 0, self.view.frame.size.width, _logoview.frame.size.height);
    [_videoContainerView addSubview:_logoview];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	[defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:self.videoPlayerViewController];
	[defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayerViewController.moviePlayer];

}*/

- (IBAction) prepareToPlay:(UISwitch *)sender
{
    //[self.videoPlayerViewController.moviePlayer prepareToPlay];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [Global sharedInstance].isShowingLandscapeView = NO;
    [self.navigationController.navigationBar setHidden:NO];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_STOP_VIDEOPLAYER object:nil];

	// Beware, viewWillDisappear: is called when the player view enters full screen on iOS 6+
    //if ([self isMovingFromParentViewController])
    //[self.videoPlayerViewController.moviePlayer pause];
}

-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //if(self.videoPlayerViewController.moviePlayer)
    
    //if(_play)
    //    [self.videoPlayerViewController.moviePlayer stop];
}

#pragma mark - Notifications

- (void) videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification
{
    
    UIViewController *parent = self;
    Class DetailsViewClass = [DetailsViewController class];
    if(![parent isKindOfClass:DetailsViewClass])
    {
        //[self.videoPlayerViewController.moviePlayer stop];
        
    }
    else{
    
    }

   
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

- (void) initUI
{
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-20,9999);
    
 
    
    PFFile *imagefile = [_obj objectForKey:@"image"];
    if(imagefile != NULL)
    {
        
        [imagefile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 320 , 320)];
            imageView.image = thumbnailImage;
            [_scrollview addSubview:imageView];
        }];
        
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake(10, 325, self.view.frame.size.width, 25)];
    titleLabel.text = [NSString stringWithFormat:@"%@",
                       [_obj objectForKey:@"name"]];
    
    titleLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [titleLabel setNumberOfLines:0];
    [titleLabel sizeToFit];
    [_scrollview addSubview:titleLabel];
    
    
    [_product setObject:titleLabel.text forKey:@"name"];
    [_product setObject:_obj.objectId forKey:@"id"];
    
    [titleLabel setFrame:CGRectMake(10,  titleLabel.frame.origin.y+5, self.view.frame.size.width-20, titleLabel.frame.size.height)];
    
    int y = titleLabel.frame.size.height +titleLabel.frame.origin.y +5 ;
    
    _sizes = [[_obj objectForKey:@"size"] componentsSeparatedByString:@"\n"];

    NSArray* size = [[_sizes objectAtIndex:0] componentsSeparatedByString:@":"];

    if(_price == nil)
    {
        _price = [[UILabel alloc] initWithFrame:CGRectMake(0, y  ,320 , 18)];
        _price.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        _price.textAlignment = UITextAlignmentCenter;
        _price.text =[NSString stringWithFormat:@"£%@",[size objectAtIndex:1]];
        _price.textColor = [UIColor darkGrayColor];
        
        [_scrollview addSubview:_price];
        
        
        [_product setObject:[size objectAtIndex:0] forKey:@"size"];
        
        [_product setObject:[size objectAtIndex:1] forKey:@"price"];
    }
    
    y = y + 18+ 10;
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width-20, 45)];
    desc.text = [NSString stringWithFormat:@"%@",
                 [_obj objectForKey:@"description"]];
    
    desc.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    [desc setLineBreakMode:UILineBreakModeWordWrap];
    [desc setNumberOfLines:0];
    [desc sizeToFit];
    desc.textColor = [UIColor blackColor];
    desc.textAlignment = UITextAlignmentCenter;
    desc.frame =CGRectMake(10, y ,self.view.frame.size.width-20,desc.frame.size.height);
    
    [_scrollview addSubview:desc];
    
    y = desc.frame.origin.y + desc.frame.size.height + 10;
    
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40,
                                                            y+10,
                                                            self.view.frame.size.width - 80,
                                                            1)];
    line.backgroundColor = [UIColor blackColor];
    
    [_scrollview addSubview:line];
    
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y + 25
                                                               ,300, 15)];
    sizeLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    
    sizeLabel.textColor = [UIColor blackColor];
    sizeLabel.textAlignment = UITextAlignmentCenter;
    sizeLabel.text = @"Sizes";
    [_scrollview addSubview:sizeLabel];

    
    y = y + 25 + 10 + 10;
    
    int margin = 20;
    
    if (_sizes.count == 1)
    {
        margin = 20 + 2*(((54/2) + (280/3 - 54/2))/2);
    }
    else if (_sizes.count == 2)
    {
        margin = 20 + ((54/2) + (280/3 - 54/2))/2;
    }
    
    for (int i =0; i < _sizes.count; i++) {
        
        NSArray* size = [[_sizes objectAtIndex:i] componentsSeparatedByString:@":"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(margin + i*(54/2) + i*(280/3 - 54/2) , y, 54/2, 54/2);
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        button.titleLabel.textColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollview addSubview:button];
        [_buttons addObject:button];
        
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x + 54/2 + 5, y
                                                                       ,280/3 - 54/2, 54/2)];
        sizeLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        sizeLabel.textColor = [UIColor blackColor];
        sizeLabel.textAlignment = UITextAlignmentLeft;
        sizeLabel.text = [size objectAtIndex:0];
        [_scrollview addSubview:sizeLabel];
        
        if(i == 0)
        {
              [button setImage:[UIImage imageNamed:@"dotwithcircle"] forState:UIControlStateNormal];
        }
     
    }
    [_scrollview setContentSize:CGSizeMake(self.view.frame.size.width, y +  200)];
    
    
    /*
    if([_obj objectForKey:@"notes"])
    {
        UILabel *notes = [[UILabel alloc] initWithFrame:CGRectMake(10,y
                                                               ,300, 15)];
        notes.font =  [UIFont fontWithName:@"HelveticaNeue-Italic" size:13];
    
        notes.textColor = [UIColor lightGrayColor];
        notes.textAlignment = UITextAlignmentCenter;
        notes.text = [NSString stringWithFormat:@"%@", [_obj objectForKey:@"notes"] ];
    
        [notes setLineBreakMode:UILineBreakModeWordWrap];
        [notes setNumberOfLines:0];
        [notes sizeToFit];
        [_scrollview addSubview:notes];
        [_scrollview setContentSize:CGSizeMake(self.view.frame.size.width, y + notes.frame.size.height + 10)];
    }
    */
    
}

-(IBAction)buttonClicked:(id)sender
{
    NSArray* size = [[_sizes objectAtIndex:[sender tag]] componentsSeparatedByString:@":"];
    _price.text =[NSString stringWithFormat:@"£%@",[size objectAtIndex:1]];
    
    [_product setObject:[size objectAtIndex:0] forKey:@"size"];
    [_product setObject:[size objectAtIndex:1] forKey:@"price"];
    
  
    [_buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [_buttons objectAtIndex:idx];
        [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        
        if(idx == [sender tag])
        {
            [button setImage:[UIImage imageNamed:@"dotwithcircle"] forState:UIControlStateNormal];
            
        }
        
    }];
}

-(IBAction)shareOnKakao:(id)sender
{
  
}

-(IBAction)shareOnTwitter:(id)sender
{
    /*
    [controllerSLC setInitialText:@"First post from my iPhone app"];
    [controllerSLC addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
    [controllerSLC addImage:[UIImage imageNamed:@"test.jpg"]];
    */
    
    NSArray* dates = [[Utilities getDateString:[[_obj objectForKey:@"UTC"] integerValue] format:10]  componentsSeparatedByString:@"-"];
    
    
    
    //NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    

    
    
    NSString* initialText = [NSString stringWithFormat:@"%@ ILOVESTAGE tickets on %@, %@ @%@ for £%@!Please DM your full name & email address to book your tickets.",
                             [_obj objectForKey:@"name"],
                             [dates objectAtIndex:0],
                             [dates objectAtIndex:1],
                             [dates objectAtIndex:2],
                             [_obj objectForKey:@"groupdiscountprice"]
                            
                             
                             ];
    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:initialText];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
    else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        { SLComposeViewController *tweetSheet = [SLComposeViewController
                                                 composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:initialText];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            //inform the user that no account is configured with alarm view.
        }
    }
}

- (IBAction)postStatusUpdateClick:(UIButton *)sender {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    NSArray* dates = [[Utilities getDateString:[[_obj objectForKey:@"UTC"] integerValue] format:10]  componentsSeparatedByString:@"-"];
    
  
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    
 
    NSString* title = [NSString stringWithFormat:@"%@ ILOVESTAGE group tickets",[_obj objectForKey:@"name"]];
   
    NSString* description = [NSString stringWithFormat:@"%@ ILOVESTAGE group tickets on %@, %@ @%@ for £%@! %d%% off!\nPlease DM your full name & email address to book your tickets.",
                             [_obj objectForKey:@"name"],
                             [dates objectAtIndex:0],
                             [dates objectAtIndex:1],
                             [dates objectAtIndex:2],
                             [_obj objectForKey:@"groupdiscountprice"],
                             
                            _percentage];
    
    FBLinkShareParams *params = [[FBLinkShareParams alloc] initWithLink:nil
                                                                   name:title
                                                                caption:@"ILOVESTAGE"
                                                            description:description
                                                                picture:nil];
    NSLog(@"%@",description);
    BOOL isSuccessful = NO;
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        NSLog(@"canPresentShareDialogWithParams");
        FBAppCall *appCall = [FBDialogs presentShareDialogWithParams:params
                                                         clientState:nil
                                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                                 if (error) {
                                                                     NSLog(@"Error: %@", error.description);
                                                                 } else {
                                                                     NSLog(@"Success!");
                                                                 }
                                                             }];
        isSuccessful = (appCall  != nil);
    }
    if (!isSuccessful && [FBDialogs canPresentOSIntegratedShareDialogWithSession:[FBSession activeSession]]){
       
        // Next try to post using Facebook's iOS6 integration
        isSuccessful = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                initialText:description
                                                                      image:nil
                                                                        url:nil
                                                                    handler:nil];
    }
    if (!isSuccessful) {
        [self performPublishAction:^{
            NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", [UserAccount sharedInstance].firstname, [NSDate date]];
            
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            
            connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
            | FBRequestConnectionErrorBehaviorAlertUser
            | FBRequestConnectionErrorBehaviorRetry;
            
            [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                 completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                     [self showAlert:message result:result error:error];
                     //self.buttonPostStatus.enabled = YES;
                 }];
            [connection start];
            
            //self.buttonPostStatus.enabled = NO;
        }];
    }
}

- (void)performPublishAction:(void(^)(void))action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
    
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    if(scrollView.contentOffset.y < 64)
    {
        [UIView animateWithDuration:0.5f animations:
         ^{
     
             //self.top.backgroundColor =  [UIColor clearColor];
             self.top.alpha = 0;
         } completion:
         ^(BOOL finished)
         {
         
         }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:
         ^{
             self.top.alpha = 0.5;
             //self.top.backgroundColor =  UIColorFromRGB(0x111111);
         } completion:
         ^(BOOL finished)
         {
             
         }];

    }
    
    if(!_scrolling)
    {
        _scrolling = YES;
        
       // if ([self isMovingFromParentViewController])
       //[self.videoPlayerViewController.moviePlayer pause];
      
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_scrolling)
    {
        _scrolling = NO;
    }
}

-(IBAction)viewMap:(id)sender
{
    //[_videoPlayerViewController.moviePlayer pause];
    
     AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:_mapViewController.view];
}

-(IBAction)booktickets:(id)sender
{

    //[_videoPlayerViewController.player pause];
    
     if(![UserAccount sharedInstance].loggedin)
     {
         _ordernowBtn.selected = YES;
         UINavigationController *vc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewNaviagtionController"];
         
         [self presentViewController:vc animated:NO completion:nil];
     
     }
     else
     {
     
     }
}

- (void)updateImage
{
 
    
}
/*
-(BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
*/


-(void)viewDidLayoutSubviews {
    
    if([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height){
        
        //Keyboard is in Portrait
         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        _scrollview.scrollEnabled = YES;
        [_top setHidden:NO];
        [_backButton setHidden:NO];
        
    }
    
}

@end
