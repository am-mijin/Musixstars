//
//  NotificationsViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 26/09/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "NotificationsViewController.h"
#import "SWRevealViewController.h"
#import "UserProfileViewController.h"

#import "AddVideosViewController.h"
#import "MyticketDetailsViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController



-(void)viewDidLayoutSubviews
{
      [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"NOTIFICATIONS", @"");
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    self.view.backgroundColor = [UIColor whiteColor];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    _messageLabel.backgroundColor = [UIColor clearColor];
    //_currentMenu = kNotification;
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Global sharedInstance].curMenu = NOTIFICATIONS;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-navigation"] forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
    
    
    if([UserAccount sharedInstance].loggedin)
    {
        [self getNotification];
        
    }
    
    [self initUI];
    
}

- (void)initUI
{
    [self.aTable reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNotification
{
    [_messageLabel setHidden: YES];
    [self showLoading:@"Loading"];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    
    //if([[UserAccount sharedInstance].role isEqualToString:@"standard"])
    //    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    //else
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    
    [query orderByDescending:@"createdAt"];
    
 
    
  
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if ([pullToReloadHeaderView status] == kPullStatusLoading)
         {
             [self performSelector:@selector(pullDownToReloadActionFinished) withObject:nil afterDelay: 0.0f];
         }
         
         
         [SVProgressHUD dismiss];
         if( !error )
         {
             
             [UserAccount sharedInstance].activities  = [objects mutableCopy];
        
    
             
         }
         dispatch_async(dispatch_get_main_queue(),^{
             
             
             [self initUI];
             
         });
         
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
 
    return  [[UserAccount sharedInstance].activities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"LikeNotificationCell";
    
    CellIdentifier = @"PerkNotificationCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  
    PFObject* activity = [[UserAccount sharedInstance].activities objectAtIndex:indexPath.row];
    
    
    NSDate *updated = [activity createdAt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM HH:mm"];
    cell.date.text = [dateFormat stringFromDate:updated];
    
    PFUser *user = [activity objectForKey:@"fromUser"];
    PFUser *video = [activity objectForKey:@"video"];
    cell.label2.text = [self updatedDate:[activity createdAt]];
   
    PFObject *perk = [activity objectForKey:@"perk"];
    
    
    
    [perk fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NSLog(@"%@", [perk objectForKey:@"title"]);
            
            cell.label1.text = [perk objectForKey:@"title"];
            
            cell.label2.text = [NSString stringWithFormat:@"£ %.2f",
                                [[perk objectForKey:@"price"] floatValue]];
        }
    }];
    
    
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            
            PFObject *postAuthor = [object objectForKey:@"firstname"];
            NSLog(@"%@",postAuthor);
            
            [video fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    
                    PFObject *video_title = [object objectForKey:@"title"];
                    if([[activity objectForKey:@"type"] isEqualToString:@"like"])
                    {
                        cell.label1.text = [NSString stringWithFormat:@"%@ loved %@",
                                            postAuthor,video_title];
                    }
                    else
                    {
                        cell.status.text = [NSString stringWithFormat:@"%@ sponsored \"%@\"",
                                            postAuthor,video_title];
                    }
                }
            }];
        }
    }];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(CustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

#pragma mark -

-(void) pullDownToReloadActionFinished {
	[self.pullToReloadHeaderView setLastUpdatedDate: [NSDate date]];
	[self.pullToReloadHeaderView finishReloading:self.aTable animated:YES];
}

-(void) pullDownToReloadAction {
    
    [self getNotification];
}

@end
