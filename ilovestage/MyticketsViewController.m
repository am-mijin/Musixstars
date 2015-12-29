//
//  MyticketsViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 26/09/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "MyticketsViewController.h"
#import "SWRevealViewController.h"
#import "UserProfileViewController.h"
#import "VideoDetailsViewController.h"
#import "AddVideosViewController.h"
#import "MenuTableViewController.h"

@interface MyticketsViewController ()

@property (weak, nonatomic)  IBOutlet UIView *artistOptionView;
@property (weak, nonatomic)  IBOutlet UIView *userOptionView;
@property (weak, nonatomic)  IBOutlet UIView *customAlertview;
@property (weak, nonatomic)  IBOutlet NSLayoutConstraint *tableBottomContraint;
@property (weak, nonatomic)  IBOutlet UIView *alertView;
@property (weak, nonatomic)  IBOutlet UIButton *addVideoBtn;
@property (weak, nonatomic)  IBOutlet UIBarButtonItem *rightBtn;

@property (readwrite)  int currentMenu;
@end

@implementation MyticketsViewController
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    
    _addVideoBtn.hidden = YES;
   // _tableBottomContraint.constant= - _addVideoBtn.frame.size.height;
    if([UserAccount sharedInstance].loggedin)
    {
        if([[UserAccount sharedInstance].role isEqualToString:kStandard])
        {
           // self.aTable.frame =  CGRectMake(0, 0, 320, self.view.frame.size.height);
         
            
            _addVideoBtn.hidden = YES;
        }
        else
        {
            
            _addVideoBtn.hidden = NO;
            //_tableBottomContraint.constant= 0;
            
           // self.aTable.frame =  CGRectMake(0, 0, 320, self.view.frame.size.height - _addVideoBtn.frame.size.height );
        }
    }
    else
    {
        
    }
    
    self.aTable.frame =  CGRectMake(0, 0, 320, self.view.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"MY ACCOUNT", @"");
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    self.view.backgroundColor = UIColorFromRGB(0xebebeb);
    
    self.aTable.backgroundColor =[UIColor clearColor];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _currentMenu = kNotification;
    
    
    _userOptionView.frame = CGRectMake(0, self.view.frame.size.height,
                                       self.view.frame.size.width,
                                       112);
    [self.view addSubview:_userOptionView];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Global sharedInstance].curMenu = MYACCOUNT;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-navigation"] forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
    
    
    if([UserAccount sharedInstance].loggedin)
    {

        if([[UserAccount sharedInstance].role isEqualToString:kStandard])
        {
            [self.aTable setHidden:NO];
            
            [self showLoading:@"Loading"];
            [self queryMyActivity:0];
            
        }
        else
        {
            
            if([Global sharedInstance].needRefreshAccount  ||
               ![[UserAccount sharedInstance].contents count])
            {
                [Global sharedInstance].needRefreshAccount = NO;
                
                [self showLoading:@"Loading"];
                [self queryMyContents:0];
               
            }
        }
    }
    
    
    [self initUI];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [_customAlertview setHidden:YES];
    [_userOptionView removeFromSuperview];
}

- (void)initUI
{
    BOOL update = NO;
    [_signinBtn setHidden: YES];
    [self.aTable setHidden:NO];
    [_messageLabel setHidden: NO];
    _rightBtn.image  = nil;
    
    
    if([UserAccount sharedInstance].loggedin)
    {
        if([[UserAccount sharedInstance].role isEqualToString:kStandard])
        {
            _rightBtn.image = [UIImage imageNamed:@"user"];
            if([[Cache sharedInstance].data count])
            {
                update = YES;
            }
        }
        else if([[UserAccount sharedInstance].role isEqualToString:kAdmin])
        {
            _rightBtn.image = [UIImage imageNamed:@"admin"];
            if([[UserAccount sharedInstance].contents count])
            {
                update = YES;
            }
            
        }
        else if([[UserAccount sharedInstance].role isEqualToString:kArtist])
        {
            _rightBtn.image = [UIImage imageNamed:@"agent"];
           
            if([[UserAccount sharedInstance].contents count])
            {
                update = YES;
            }
            
        }
        self.aTable.rowHeight = 93;
        [self.aTable reloadData];
        
      
        if(update)
        {
            [_messageLabel setHidden: YES];
            [self.aTable setHidden:NO];
            [self.aTable reloadData];
        }
        else
        {
            [_messageLabel setHidden: NO];
            [self.aTable setHidden:YES];
            _messageLabel.text =  NSLocalizedString(@"NO ACTIVITIES", @"");
        }
        
    }
    else
    {
        [self.aTable setHidden:YES];
        [_signinBtn setHidden: NO];
        _messageLabel.text = NSLocalizedString(@"SIGN INTO MUSIXSTARS", @"");
    }
    
}

- (IBAction)viewUserprofile:(id)sender
{
    UserProfileViewController *vc = (UserProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryMyActivity:(int)skip
{
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    //query.limit = 14;
    //query.skip = skip; // skip the first 10 results
    
    //[query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if ([pullToReloadHeaderView status] == kPullStatusLoading)
         {
             [self performSelector:@selector(pullDownToReloadActionFinished) withObject:nil afterDelay: 0.0f];
         }
         if( !error )
         {
             [UserAccount sharedInstance].contents  = [objects mutableCopy];
             NSLog(@"__ %d",[[UserAccount sharedInstance].contents count]);
             
             dispatch_async(dispatch_get_main_queue(),^{
                 // [self.hud hide:YES];
                 
                 [SVProgressHUD dismiss];
                 [self.aTable reloadData];
                 if([objects count])
                 {
                     self.aTable.hidden = NO;
                     [_messageLabel setHidden: YES];
                 }
             });
             
         }
     }
     ];
    
}

- (void)queryMyContents:(int)skip
{
  
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Musixstars"];
    
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    //query.limit = 14;
    //query.skip = skip; // skip the first 10 results
    
    //[query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if ([pullToReloadHeaderView status] == kPullStatusLoading)
         {
             [self performSelector:@selector(pullDownToReloadActionFinished) withObject:nil afterDelay: 0.0f];
         }
         
         if( !error )
         {
            [UserAccount sharedInstance].contents  = [objects mutableCopy];
             NSLog(@"__ %d",[[UserAccount sharedInstance].contents count]);
           
             dispatch_async(dispatch_get_main_queue(),^{
                // [self.hud hide:YES];
                 
                 [SVProgressHUD dismiss];
                 [self.aTable reloadData];
                 if([objects count])
                 {
                     self.aTable.hidden = NO;
                     [_messageLabel setHidden: YES];
                 }
             });
             
         }
     }
     ];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if(![[UserAccount sharedInstance].role isEqualToString:kStandard])
//    {
//        return [[UserAccount sharedInstance].contents count];
//       
//    }
  return [[UserAccount sharedInstance].contents count];
 //return [[Cache sharedInstance].data count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    v.backgroundColor = [UIColor clearColor];
    
    
    UILabel* label  = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, tableView.frame.size.width-40, 25)];
    
    label.text = @"+  Add Videos";
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"GothamRounded-Bold" size:12];
    [v addSubview:label];

    

    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
     return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"Cell";
    
    if([[UserAccount sharedInstance].role isEqualToString:kStandard])
    {
        CellIdentifier = @"Bought";
    }
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([[UserAccount sharedInstance].role isEqualToString:kStandard])
    {
        
        //if([[UserAccount sharedInstance].contents count] )
        {
            PFObject* activity = [[UserAccount sharedInstance].contents objectAtIndex:indexPath.row];
            NSDate *updated = [activity updatedAt];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"d MMM"];
            cell.date.text = [dateFormat stringFromDate:updated];
            //cell.date.text = [self updatedDate:[activity objectForKey:@"createdAt"]];
            
            PFObject *perk = [activity objectForKey:@"perk"];
            
            
            
            [perk fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    NSLog(@"%@", [perk objectForKey:@"title"]);
                    
                    cell.label1.text = [perk objectForKey:@"title"];
                    
                    cell.label2.text = [NSString stringWithFormat:@"£ %.2f",
                                                          [[perk objectForKey:@"price"] floatValue]];
                }
            }];
                
            
            PFObject *video = [activity objectForKey:@"video"];
            [video fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    
                    //cell.label1.text = [video objectForKey:@"artist"];
                    
                    cell.status.text =[NSString stringWithFormat:@"Sponsored %@",
                                      [video objectForKey:@"artist"]];
                    
                    
                    NSString *url = [video objectForKey:@"thumbnail"];
                    
                    NSURL *thumbnailURL =  [NSURL URLWithString:url];
                    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                     {
                         cell.thumbnail.image = [UIImage imageWithData:data];
                         
                     }];
                }
            }];
            
            if([[activity objectForKey:@"type"] isEqualToString:@"like"])
            {
                cell.loveButton.hidden = NO;
                cell.loved.text = @"Loved";
            }
            else
            {
                //cell.price.text = @"Sponsored";
                //cell.loveButton.hidden = YES;
            }
            
        }
        
        /*
        NSArray* vidoes = [[Cache sharedInstance].data allKeys];
        NSString* key = [vidoes objectAtIndex:indexPath.row];
        
        NSDictionary* attributes = [[Cache sharedInstance].data objectForKey:key];
        NSLog(@"attributes %@",attributes);
        PFObject* video = [attributes objectForKey:@"video"];
        
        NSString *url = [video objectForKey:@"thumbnail"];
        
        NSURL *thumbnailURL =  [NSURL URLWithString:url];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             cell.thumbnail.image = [UIImage imageWithData:data];
             
         }];
        
        cell.label1.text = [video objectForKey:@"title"];
        cell.label2.text = [video objectForKey:@"artist"];
        
        cell.loved.text = @"Loved";
        cell.date.text = [self updatedDate:[video objectForKey:@"date"]];
        
        cell.loveButton.hidden = NO;*/
    }
    else
    {
       
            if([[UserAccount sharedInstance].contents count] )
            {
                PFObject* video = [[UserAccount sharedInstance].contents objectAtIndex:indexPath.row];
                
                
                NSString *url = [video objectForKey:@"thumbnail"];
                
                NSURL *thumbnailURL =  [NSURL URLWithString:url];
                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                 {
                     cell.thumbnail.image = [UIImage imageWithData:data];
                     
                 }];
                cell.loveButton.hidden = YES;
                cell.label1.text = [video objectForKey:@"title"];
                cell.loved.text = [NSString stringWithFormat:@"£ %.2f funded",[[video objectForKey:@"totalfund"] floatValue]];
                NSDate* date = [video objectForKey:@"expiryDate"];
                NSTimeInterval secondsBetween = [date timeIntervalSinceDate:[NSDate date]];
                
                int numberOfDays =  secondsBetween / 86400 +1;
                
                if(numberOfDays < 0)
                {
                    cell.date.text = @"Expired";
                }
                else if(numberOfDays == 0)
                {
                    cell.date.text = @"Expire in 1 day";
                }
                else
                {
                    cell.date.text = [NSString stringWithFormat:@"Expires in %d day%@",
                                       numberOfDays,
                                       numberOfDays >1?@"s":@""];
                }
               
                
            }
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(CustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    PFObject * booking = [[UserAccount sharedInstance].mytickets objectAtIndex:indexPath.row];
    NSLog(@"__objectId %@",booking.objectId);
    UILabel *ref = [[UILabel alloc] initWithFrame:CGRectMake(18 ,32 ,65, 10 )];
    ref.font =  [UIFont fontWithName:@"Seravek" size:8];
    ref.backgroundColor =  UIColorFromRGB(0xf3f3f3);
    ref.textAlignment = NSTextAlignmentCenter;
    ref.textColor = [UIColor darkGrayColor];
    //UIColorFromRGB(0x3491ed);
   
    //NSString *trimmedString=[[booking objectForKey:@"_id"] substringFromIndex:MAX((int)[[booking objectForKey:@"_id"] length]-8, 0)];
    
    ref.text =  booking.objectId;
    
    ref.transform = CGAffineTransformMakeRotation(-(M_PI)/2);
    [cell.contentView addSubview:ref];
    */
    /*
    if(_currentMenu == kNotification)
    {
        UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(320-20-10,cell.frame.size.height/2 -5,10,10)];
        circleView.alpha = 1;
        circleView.layer.cornerRadius = 5;
        circleView.backgroundColor = [UIColor redColor];
    
        [cell.contentView addSubview:circleView];
    }*/
    
}

-(void)fillCircleCenteredAt:(CGPoint)center
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center
                    radius:50.0
                startAngle:0.0
                  endAngle:2.0 * M_PI
                 clockwise:NO];
    [path fill];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    //NSString* ref = [Utilities getShowReference:[event objectForKey:@"showid"]];
    
    PFObject *mybooking = [[UserAccount sharedInstance].mytickets objectAtIndex:indexPath.row];
    PFObject *show = [mybooking objectForKey:@"show"];

    __block int reference = 0;
    [show fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        reference = [[show objectForKey:@"reference"]  integerValue];
    }];
    

    MyticketDetailsViewController *vc = (MyticketDetailsViewController*)
    [self.storyboard instantiateViewControllerWithIdentifier:@"MyticketDetailsViewController"];
    vc.booking =mybooking;
    vc.show = [[Global sharedInstance].shows objectAtIndex:reference-1];
    [self.navigationController pushViewController:vc animated:YES];
     
    */
    
    if(![[UserAccount sharedInstance].role isEqualToString:kStandard])
    {
        VideoDetailsViewController *vc = (VideoDetailsViewController*)
        [self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetailsViewController"];
    
        PFObject* video = [[UserAccount sharedInstance].contents objectAtIndex:indexPath.row];
        vc.obj = video;
        vc.mode = kEditVideo; 
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

#pragma mark -

-(void) pullDownToReloadActionFinished {
	[self.pullToReloadHeaderView setLastUpdatedDate: [NSDate date]];
	[self.pullToReloadHeaderView finishReloading:self.aTable animated:YES];
}

-(void) pullDownToReloadAction {
    if([[UserAccount sharedInstance].role isEqualToString:kStandard])
    {
        
        [self queryMyActivity:0];
        
    }
    else
    {
        [self queryMyContents:0];
    }
}

-(IBAction)addVideos:(id)sender
{
    AddVideosViewController *vc = (AddVideosViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddVideosViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)login:(id)sender
{
    if(![UserAccount sharedInstance].loggedin)
    {
        UINavigationController *vc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewNaviagtionController"];
    
        [self presentViewController:vc animated:NO completion:nil];
    }
}

-(IBAction)cancel:(id)sender
{
    _customAlertview.hidden = YES;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         _userOptionView.frame = CGRectMake(0, self.view.frame.size.height,
                                                            _userOptionView.frame.size.width,
                                                            _userOptionView.frame.size.height);
                     }];
    
    
}

-(IBAction)showOptions:(id)sender
{
    /*
    _customAlertview.hidden = NO;
    
    if([sender tag] == 0)
    {
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             _userOptionView.frame = CGRectMake(0,
                                                                self.view.frame.size.height -_userOptionView.frame.size.height,
                                                                _userOptionView.frame.size.width,
                                                                _userOptionView.frame.size.height);
                         }];
    }
    else
    {
        
    }*/
    
    MenuTableViewController *vc = (MenuTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuTableViewController"];
    
    [self presentViewController:vc animated:NO completion:nil];
    
}

@end
