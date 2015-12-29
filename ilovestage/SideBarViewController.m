//
//  SideBarViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "SideBarViewController.h"
#import "SWRevealViewController.h"

#import "NotificationsViewController.h"
#import "SubViewController.h"
#import "UserAccount.h"
#import "Global.h"

@interface SideBarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, weak) IBOutlet UIButton* notification;


@end

@implementation SideBarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //[[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    //self.view.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

    //self.tableView.separatorColor =  [UIColor blackColor];
    //[UIColor colorWithRed:48.0/255.0 green:68.0/255.0 blue:98.0/255.0 alpha:1.0];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    _menuItems = @[@"feeds", @"my account", @"about"];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    UIImageView* backgroundview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mcqueenBG"]];
    [backgroundview setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.revealViewController.view addSubview:backgroundview];
    [self.revealViewController.view sendSubviewToBack:backgroundview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotifications:) name:ReacieveNotificationNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [self.tableView reloadData];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.translucent = YES;
    
    _notification.hidden = YES;
    
    if([UserAccount sharedInstance].loggedin)
    {
        [self updateNotificaions];
    }
    
    
    
}

- (void) updateNotifications:(NSNotification *)notification
{
    [self updateNotificaions];
}

-(void)updateNotificaions
{
    if(![[UserAccount sharedInstance].role isEqualToString:@"standard"])
    {
        {
            [_notification setTitle:[NSString stringWithFormat:@"%d",
                                     [UIApplication sharedApplication].applicationIconBadgeNumber] forState:UIControlStateNormal];
            
            _notification.hidden = NO;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    //cell.label1.textColor =  UIColorFromRGB(0x413c3d);
    cell.button.selected = NO;
    
    if([Global sharedInstance].curMenu == indexPath.row)
    {
        cell.button.selected = YES;
        
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //[self performSegueWithIdentifier:@"mySegueId" sender:self];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    //NSLog(@"prepareForSegue");
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    //[Global sharedInstance].curMenu  = indexPath.row;
    
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            
            /*
             NSLog(@"--%@",segue.identifier);
             if ([segue.identifier isEqualToString:@"log out"]) {
             [self logout];
             
             [[Global sharedInstance] reset];
             [[UserAccount sharedInstance] reset];
             
             AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [app save];
             //                SubViewController *viewController = (SubViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SubViewController"];
             //                [navController setViewControllers: @[viewController] animated: YES ];
             
             [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: NO];
             
             
             //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             UINavigationController *vc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewNaviagtionController"];
             
             
             [self presentViewController:vc animated:NO completion:nil];
             
             }
             else*/
            {
                [Global sharedInstance].curMenu = indexPath.row;
                
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            }
        };
    }
}

-(void)logout
{
    
    
}

////////////////////////////////////////////////////////////////////////////////
// RequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(AppLinkCenter *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(AppLinkCenter *)request didReceiveResponse:(NSURLResponse *)response {
    
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
    
    
    if (result != NULL) {
        NSDictionary * results = (NSDictionary*)result;
        switch ([[results objectForKey:@"errorCode"] intValue ]) {
            case 0:
                /*
                 [[Global sharedInstance] reset];
                 [[UserAccount sharedInstance] reset];
                 
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 UINavigationController *vc = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewNaviagtionController"];
                 
                 //[vc setModalPresentationStyle:UIModalPresentationFullScreen];
                 [self presentViewController:vc animated:NO completion:nil];
                 
                 [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: NO];
                 */
                break;
        }
        
    }
    
    
};

-(IBAction)ShowNotifications:(id)sender
{
    if([UserAccount sharedInstance].loggedin)
    {
    
        NotificationsViewController *vc = (NotificationsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[vc] animated: NO ];
      
        [Global sharedInstance].curMenu = NOTIFICATIONS;
        
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
}
@end
