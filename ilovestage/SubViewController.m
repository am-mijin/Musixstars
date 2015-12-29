//
//  SubViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "SubViewController.h"
#import "SWRevealViewController.h"
#import "NSString+Date.h"
#import "CustomButton.h"
#import "UserAccount.h"
#import "AVPlayerDemoPlaybackViewController.h"
#import "MyticketsViewController.h"
#import "WelcomeViewController.h"
#import "VideoDetailsViewController.h"
#import "ParseAPI.h"

@interface SubViewController ()
{
    id savedObj;
}
@property (readwrite) int request;
@property (strong, nonatomic)  NSMutableDictionary*temp;
@property (strong, nonatomic)  XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@property (strong, nonatomic)  SearchVideosViewController*searchVideosViewController;
@property (assign)  BOOL searchVideoMode;

@end

@implementation SubViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.sidebarButton.target = self.revealViewController;
    self.sidebarButton.action = @selector(revealToggle:);
    
    self.tryagain.titleLabel.text = NSLocalizedString(@"TAP TO REFRESH", @"");
    self.tryagain.titleLabel.font = [UIFont fontWithName:@"Seravek" size:18];
    
    _searchVideosViewController = (SearchVideosViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchVideosViewController"];
    _searchVideosViewController.delegate = self;
    
    //_searchVideosViewController.view.frame =CGRectMake( self.view.frame.size.width , 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //[self setupRightButton];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    /*
     NSInteger time  = [[NSDate date] timeIntervalSince1970] +[Utilities addTimezone];
     
     */
    
    self.view.backgroundColor = [UIColor whiteColor];
    [aTable setSeparatorInset:UIEdgeInsetsZero];
    
    aTable.hidden = NO;
    //self.aTable.backgroundColor = UIColorFromRGB(0x111111);
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    if([Global sharedInstance].curMenu == MYACCOUNT)
    {
        MyticketsViewController *vc = (MyticketsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MyticketsViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [Global sharedInstance].needRefreshAccount = YES;
        [navController setViewControllers: @[vc] animated: NO ];
        
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: NO];
    }
    else
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.hidden = NO;
        self.title = @"";
        [Global sharedInstance].curMenu = FEEDS;
        
        if(savedObj)
        {
            [self likeAction:savedObj];
            savedObj= nil;
        }
        else
        {
            if(![[Global sharedInstance].feeds count]
               || [Global sharedInstance].needRefreshFeeds )
            {
                [Global sharedInstance].needRefreshFeeds = NO;
                [self showLoading:@"Loading..."];
                [self queryFeeds];
            }
            else
            {   self.aTable.hidden = NO;
                [self.aTable reloadData];
            }
        }
    }
}

- (void)getEvents
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSLog(@"System time: %@", [dateFormatter stringFromDate:[NSDate date]]);
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Aqtobe"]];
    
    NSString *start = [dateFormatter stringFromDate:[NSDate date]] ;
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:+3];
    NSDate *endDate = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    NSString *end = [dateFormatter stringFromDate:endDate];
    
    _request =  kEvents;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   start, @"start",
                                   end, @"end",
                                   @"ticketsbooked", @"sort",
                                   @"pending",@"status",
                                   nil];
    
    [AppLinkCenter requestWithPath:@"events"
                         andParams:params
                     andHttpMethod:@"GET"
                       andDelegate:self];
    
    NSLog(@"%@",params);
}

- (void)getSchedule
{
    
    [Global sharedInstance].last_updated_time = [[NSDate date] timeIntervalSince1970] +[Utilities addTimezone];
    
    NSString* datestr = [NSString stringDateFromDate:[NSDate date]];
    
    NSArray* dates = [datestr componentsSeparatedByString:@" "];
    /*
     NSDate *yesterday = [today dateByAddingTimeInterval: -86400.0];
     NSDate *thisWeek  = [today dateByAddingTimeInterval: -604800.0];
     NSDate *lastWeek  = [today dateByAddingTimeInterval: -1209600.0];
     
     NSDate *thisMonth = [today dateByAddingTimeInterval: -2629743.83];
     NSDate *lastMonth = [today dateByAddingTimeInterval: -5259487.66];
     
     dispatch_async(dispatch_get_main_queue(),^{
     [self showLoading:@"Loading schedule..."];
     
     });*/
    
}

-(void)setupRightButton {
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 32, 32);
    backView.frame = button.frame;
    
    [button setBackgroundImage:[UIImage imageNamed:@"01_viewmore"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(viewmore) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:button];
    
    //_sidebarRightButton = [[UIBarButtonItem alloc] initWithCustomView:backView];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backView]];
    /*
     [_sidebarRightButton setTitleTextAttributes:  [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor blackColor], NSForegroundColorAttributeName,
     [UIFont fontWithName:@"Seravek-Light" size:12], NSFontAttributeName, nil] forState:UIControlStateNormal];*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateUI
{
    
}

-(void)queryFeeds
{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Musixstars"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if ([pullToReloadHeaderView status] == kPullStatusLoading)
         {
             [self performSelector:@selector(pullDownToReloadActionFinished) withObject:nil afterDelay: 0.0f];
         }
         
         
         if( !error )
         {
             
             [Global sharedInstance].feeds  = [objects mutableCopy];
             NSLog(@"%d",       [[Global sharedInstance].feeds count]);
             dispatch_async(dispatch_get_main_queue(),^{
             
                 [SVProgressHUD dismiss];
                 [self.aTable setHidden:NO];
                 [self.aTable reloadData];
               
                 
             });
             
             
             
         }
     }
     ];
    
    
    [self.aTable reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[Global sharedInstance].feeds count];
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 
 int h = 10;
 UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, h)];
 v.backgroundColor = [UIColor clearColor];
 
 
 //    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient:TABLE_SECTION];
 //    bgLayer.frame = v.bounds;
 //    [v.layer insertSublayer:bgLayer atIndex:0];
 //
 //    if(_lightView == nil)
 //    {
 //        _lightView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
 //        _lightView.backgroundColor = [UIColor clearColor];
 //        [_lightView setImage:[UIImage imageNamed:@"Light_Off_Full"]];
 //    }
 
 
 
 return v;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 
 int h = 10;
 return h;
 
 }*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        
        
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    PFObject* video = [[Global sharedInstance].feeds objectAtIndex:indexPath.row];
    
    
    NSString *url = [video objectForKey:@"thumbnail"];
    
    NSURL *thumbnailURL =  [NSURL URLWithString:url];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         cell.thumbnail.image = [UIImage imageWithData:data];
         
     }];
    
    cell.button.tag = indexPath.row;
    cell.loveButton.tag = indexPath.row;
   
  
    /*
    int likecount = [[video objectForKey:@"likes"] integerValue];
    if(likecount > 0)
        cell.loved.text = [NSString stringWithFormat:@"%d Loved",likecount];
    else
        cell.loved.text = @"";
    */
    if( [[Cache sharedInstance] isVideoLikedByCurrentUser:video])
    {
        cell.loveButton.selected = YES;
    }
    else
    {
        cell.loveButton.selected = NO;
    }
    
    cell.headerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:0/255.0 alpha:1.0];
    
    if(cell.loveButton.selected)
    {
        cell.headerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:78/255.0 blue:134/255.0 alpha:1.0];
    }
    
    cell.label1.text = [video objectForKey:@"title"];
     NSLog(@"title %@",[video objectForKey:@"title"]);
    cell.label2.text = [video objectForKey:@"artist"];
    cell.price.text = [NSString stringWithFormat:@"£ %.2f",[[video objectForKey:@"totalfund"] floatValue]];
  
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(CustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - Notifications

- (void) videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification
{
    /*
    XCDYouTubeVideo *video = notification.userInfo[XCDYouTubeVideoUserInfoKey];
    //self.titleLabel.text = video.title;
    XCDYouTubeVideoPlayerViewController* v = (XCDYouTubeVideoPlayerViewController*)notification.object;
    
    //NSURL *thumbnailURL = video.mediumThumbnailURL ?: video.smallThumbnailURL;
    
    NSURL *thumbnailURL =  video.mediumThumbnailURL;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         CustomCell* cell = (CustomCell*)[_temp objectForKey:[NSNumber numberWithInteger:v.view.tag]];
         
         cell.thumbnail.image = [UIImage imageWithData:data];
         cell.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
         
     }];*/
}

- (IBAction) play:(id)sender
{
    
    VideoDetailsViewController *vc = (VideoDetailsViewController*)
    [self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetailsViewController"];
    
    vc.obj = [[Global sharedInstance].feeds objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc animated:YES];
   
    
    /*
    CustomCell* cell = (CustomCell*)[_temp objectForKey:[NSNumber numberWithInteger:[sender tag]]];
    
    XCDYouTubeVideoPlayerViewController* v = [_controllers objectForKey:[NSNumber numberWithInteger:[sender tag]]];
    
    if(v.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
        [v.moviePlayer pause];
    }
    else
    {
        cell.thumbnail.hidden = YES;
        [v presentInView:cell.videoContainerView];
        [v.moviePlayer play];
    }*/
}

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
    if (error)
    {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        //        [alertView show];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     
     PFObject *event = [[Global sharedInstance].events objectAtIndex:indexPath.row];
     PFObject *show = [event objectForKey:@"show"];
     
     __block int reference = 0;
     [show fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
     reference = [[show objectForKey:@"reference"]  integerValue];
     }];
     
     
     DetailsViewController *vc = (DetailsViewController*)
     [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
     
     //vc.show = [[Global sharedInstance].shows objectAtIndex:reference-1];
     [self.navigationController pushViewController:vc animated:YES];
     */
}


-(IBAction)refreshAction:(id)sender
{
    [self queryFeeds];
}

-(IBAction)searchVideos:(id)sender
{
    _searchVideoMode = !_searchVideoMode;
    UIView * fromView = _searchVideosViewController.view;
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    
    // Add the to view to the tab bar view.
    [self.view addSubview:fromView];
    
    fromView.frame  =CGRectMake( self.view.frame.size.width , viewSize.origin.y, self.view.frame.size.width, viewSize.size.height);
   
    [UIView animateWithDuration:0.4 animations:
     ^{
         // Animate the views on and off the screen. This will appear to slide.
         if(_searchVideoMode)
         {
             [_rightButton setImage:[UIImage imageNamed:@"close_to_main"]];
             
             fromView.frame  =CGRectMake( 0 , viewSize.origin.y, self.view.frame.size.width, viewSize.size.height);
             
         }
         else
         {
             [_rightButton setImage:[UIImage imageNamed:@"search_icon"]];
             [_searchVideosViewController.results removeAllObjects];
             [fromView removeFromSuperview];
         }
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             
         }
     }];
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

#pragma mark -

-(void) pullDownToReloadActionFinished {
    [self.pullToReloadHeaderView setLastUpdatedDate: [NSDate date]];
    [self.pullToReloadHeaderView finishReloading:self.aTable animated:YES];
}

-(void) pullDownToReloadAction {
    [self refreshAction:nil];
}

-(IBAction)tryagain:(id)sender
{
    //[self getShows];
}

-(IBAction)didTapLoveVideoButton:(id )sender  {
    
    if([UserAccount sharedInstance].loggedin)
    {
        [self likeAction:sender];
    }
    else
    {
        savedObj = sender;
        
        UINavigationController *vc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewNaviagtionController"];
        
        [self presentViewController:vc animated:NO completion:nil];
    }
   
}

-(void)likeAction:(id)sender
{
    PFObject *video = [[Global sharedInstance].feeds objectAtIndex:[sender tag]];
    
    UIButton *button = (UIButton*)sender;
    BOOL liked = !button.selected;
    int likecount;
    
    if(liked)
    {
        likecount = [[video objectForKey:@"likes"] integerValue] + 1;
    }
    else
    {
        likecount = [[video objectForKey:@"likes"] integerValue] - 1 ;
    }
    
    [video setObject:[NSNumber numberWithInt:likecount] forKey:@"likes"];
    
    CustomCell *cell = (CustomCell *)[[sender superview]superview];
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    cell.loveButton.selected = liked;
    if(likecount > 0)
        cell.loved.text = [NSString stringWithFormat:@"%d Loved",likecount];
    else
        cell.loved.text = @"";
    
    if(liked)
    {
        
        cell.headerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:78/255.0 blue:134/255.0 alpha:1.0];
        [ParseAPI likeVideoInBackground:video block:^(BOOL succeeded, NSError *error) {
        
            if (succeeded) {
            
                [[Global sharedInstance].feeds replaceObjectAtIndex:[sender tag] withObject:video];
            
            }
            else
            {
            
            }
        }];
    }
    else
    {
         cell.headerView.backgroundColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:0/255.0 alpha:1.0];
        
        [ParseAPI  unlikePhotoInBackground:video block:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                
                [[Global sharedInstance].feeds replaceObjectAtIndex:[sender tag] withObject:video];
            }
            else
            {
                
            }
        }];
     
    }
}

//implementation of delegate method
- (void)ShowDetails:(PFObject*)video
{
    VideoDetailsViewController *vc = (VideoDetailsViewController*)
    [self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetailsViewController"];
    
    vc.obj = video;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
