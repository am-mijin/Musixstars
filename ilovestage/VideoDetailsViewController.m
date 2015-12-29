//
//  VideoDetailsViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 03/06/2015.
//  Copyright (c) 2015 Musixstars. All rights reserved.
//

#import "VideoDetailsViewController.h"
#import "CustomCell.h"
#import "AddPerkViewController.h"
#import "ParseAPI.h"
#import "BookTicketsViewController.h"

@interface VideoDetailsViewController ()

@property (strong, nonatomic)  NSMutableArray *perks;
@property (strong, nonatomic)  XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@property (nonatomic, weak) IBOutlet UIView *videoContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *loveLabel;
@property (nonatomic, weak) IBOutlet UIButton *loveButton;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIView *header;
@property (nonatomic, weak) IBOutlet UIView *contributeView;
@property (nonatomic, weak) IBOutlet UIView *sectionView;
@property (nonatomic, weak) IBOutlet UIButton *uploadButton;
@property (nonatomic, weak) IBOutlet UILabel *sectionLabel;
@property (nonatomic, weak) IBOutlet UIButton *addPerkButton;
@property (assign) int selectedPerk;
@end


@implementation VideoDetailsViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if(_mode == kDefault)
    {
        [self.aTable setFrame:self.view.bounds];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _perks = [NSMutableArray new];
    
    _selectedPerk = -1;
    [self initUI];
    
    NSString *videoIdentifier = @"";
    if(_mode == kDefault ||
       _mode == kEditVideo)
    {
        videoIdentifier = [_obj objectForKey:@"videoid"];
    }
    else if( _mode == kUploadVideo)
    {
        videoIdentifier = [[_video objectForKey:@"id"] objectForKey:@"videoId"];
    }
    
    NSLog(@"__videoIdentifier %@",videoIdentifier);
    _videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoIdentifier];
   
    
    _videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:_videoPlayerViewController];
    [defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_videoPlayerViewController.moviePlayer];
    [_videoPlayerViewController presentInView:_videoContainerView withStyle:MPMovieControlStyleEmbedded];
   
    if(_mode == kDefault )
    {
        
        _playButton.hidden = YES;
        _videoPlayerViewController.moviePlayer.shouldAutoplay = YES;
        [_videoPlayerViewController.moviePlayer play];
        
    }
    else
    {
        _videoPlayerViewController.moviePlayer.shouldAutoplay = NO;
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    if([UserAccount sharedInstance].loggedin &&
      _selectedPerk != -1)
    {
        
        BookTicketsViewController *bookTicketsViewController = (BookTicketsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BookTicketsViewController"];
        bookTicketsViewController.index = _selectedPerk;
        bookTicketsViewController.obj = _obj;
        _selectedPerk = -1;
        [self.navigationController pushViewController:bookTicketsViewController animated:YES];
        
        
    }
    else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
        
        [self.navigationController.navigationBar setHidden:YES];
        
        self.aTable.sectionHeaderHeight =_header.frame.size.height;
        [self.aTable reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [_videoPlayerViewController.moviePlayer pause];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initUI
{
    if(_mode == kDefault || _mode == kEditVideo )
    {
        _perks = [[_obj objectForKey:@"perks"] mutableCopy];
        
        if([[UserAccount sharedInstance].role isEqualToString:kArtist])
        {
            
            _thumbnailImageView.hidden = YES;
            _loveButton.hidden = YES;
            _playButton.hidden = NO;
            _uploadButton.hidden = YES;
            _sectionLabel.text = @"Perks";
            _addPerkButton.hidden = YES;
            
            if(_mode == kEditVideo )
            {
                _addPerkButton.hidden = NO;
                
                [_uploadButton setTitle:@"Edit Video" forState:UIControlStateNormal];
            }
            
            
        }
        else
        {
            _thumbnailImageView.hidden = YES;
            _loveButton.hidden = NO;
            _playButton.hidden = NO;
            _uploadButton.hidden = YES;
            _sectionLabel.text = @"Buy a Perk";
            _addPerkButton.hidden = YES;
        }
        
        
    }
    else if(_mode == kUploadVideo )
    {
        
        _thumbnailImageView.hidden = NO;
        _loveButton.hidden = YES;
        _playButton.hidden = NO;
        _uploadButton.hidden = NO;
        _sectionLabel.text = @"Select Perks";
        _addPerkButton.hidden = NO;
       
        [_uploadButton setTitle:@"Upload Video" forState:UIControlStateNormal];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake(20, 240 + 10, self.view.frame.size.width - 40, 25)];
    if(_mode == kDefault ||
       _mode == kEditVideo)
    {
        titleLabel.text = [NSString stringWithFormat:@"%@",
                       [_obj objectForKey:@"title"]];
  
        
    }
    else
    {
        
        titleLabel.text = [NSString stringWithFormat:@"%@",
                           [[_video objectForKey:@"snippet"] objectForKey:@"title"]];
        
    }
    
    titleLabel.font =  [UIFont fontWithName:@"GothamRounded-Bold" size:14];
    
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [titleLabel setNumberOfLines:0];
    [titleLabel sizeToFit];
    
    [_header addSubview:titleLabel];

    
    
    UILabel *totalfund = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y +titleLabel.frame.size.height +10, self.view.frame.size.width-40, 20)];
    totalfund.text = [NSString stringWithFormat:@"£ %.2f funded",[[_obj objectForKey:@"totalfund"] floatValue]];
    totalfund.font =  [UIFont fontWithName:@"GothamRounded-Book" size:14];
    
    [_header addSubview:totalfund];
    
    
    UILabel *expiryDate = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 20- 150, totalfund.frame.origin.y, 150, 20)];
 
    
    if(_mode == kDefault ||
       _mode == kEditVideo)
    {
        NSDate* date = [_obj objectForKey:@"expiryDate"];
        NSTimeInterval secondsBetween = [date timeIntervalSinceDate:[NSDate date]];
        
       
        int numberOfDays =  secondsBetween / 86400 +1;
        
        if(numberOfDays < 0)
        {
            expiryDate.text = @"Expired";
        }
        else if(numberOfDays == 0)
        {
            expiryDate.text = @"Expire in 1 day";
        }
        else
        {
            expiryDate.text = [NSString stringWithFormat:@"Expires in %d day%@",
                              numberOfDays,
                              numberOfDays >1?@"s":@""];
        }
        
        
    }
    else
        expiryDate.text = @"Expires in 30 days";
    
    
    expiryDate.textAlignment = NSTextAlignmentRight;
    expiryDate.textColor = [UIColor redColor];
    expiryDate.font =  [UIFont fontWithName:@"GothamRounded-Book" size:12];
    
    [_header addSubview:expiryDate];
    
    
    NSString* description = @"";
    if(
       _mode == kDefault ||
       _mode == kEditVideo)
    {
        description = [NSString stringWithFormat:@"%@",
                      [_obj objectForKey:@"description"]];
    
    }
    else
    {
        
        description = [NSString stringWithFormat:@"%@",
                       [[_video objectForKey:@"snippet"] objectForKey:@"description"]];
 
    }
    
    if(description.length > 0)
    {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, totalfund.frame.origin.y +totalfund.frame.size.height +10, self.view.frame.size.width-40, 20)];
        label.text = @"Description";
        label.font =  [UIFont fontWithName:@"GothamRounded-Book" size:12];
        
        [_header addSubview:label];
        
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(20, label.frame.origin.y +label.frame.size.height + 10 , self.view.frame.size.width- 40, 45)];
        desc.text = description;
        
        desc.font =  [UIFont fontWithName:@"GothamRounded-Light" size:11];
        [desc setLineBreakMode:UILineBreakModeWordWrap];
        [desc setNumberOfLines:0];
        [desc sizeToFit];
        desc.textColor = [UIColor darkGrayColor];
        desc.frame =CGRectMake(20, desc.frame.origin.y ,
                               self.view.frame.size.width - 40, desc.frame.size.height);
        
        [_header addSubview:desc];
        
        _contributeView.frame = CGRectMake(0, desc.frame.origin.y + desc.frame.size.height + 10, self.view.frame.size.width, _contributeView.frame.size.height);
        
    }
    else
    {
        
        _contributeView.frame =  CGRectMake(0, totalfund.frame.origin.y + totalfund.frame.size.height + 10, self.view.frame.size.width, _contributeView.frame.size.height);
    }
    
    
    [_header addSubview:_contributeView];
    
    _sectionView.frame = CGRectMake(0,  _contributeView.frame.origin.y + _contributeView.frame.size.height + 10, self.view.frame.size.width, 45);
    
    /*UILabel *artist = [[UILabel alloc] initWithFrame:CGRectMake(20, y, self.view.frame.size.width-20, 25)];
    
    artist.font =  [UIFont fontWithName:@"GothamRounded-Book" size:14];
    
    [_header addSubview:artist];*/
    BOOL section = NO;
    if(_mode == kDefault)
    {
        if([_perks count]-3 >0)
        {
            section = YES;
            
        }
        
    }
    else
    {
        section = YES;
    }
    
    
    if(section)
    {
        [_header addSubview:_sectionView];
        
        _header.frame = CGRectMake(0, 0, 320, _sectionView.frame.origin.y + _sectionView.frame.size.height);
    }
    
    if( [[Cache sharedInstance] isVideoLikedByCurrentUser:_obj])
    {
        _loveButton.selected = YES;
    }
    else
    {
        _loveButton.selected = NO;
    }

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
    
    if(_mode == kUploadVideo)
    {
        return [[UserAccount sharedInstance].perks count];
    }
    else
    {
        NSDate* date = [_obj objectForKey:@"expiryDate"];
        NSTimeInterval secondsBetween = [date timeIntervalSinceDate:[NSDate date]];
        
        
        int numberOfDays =  secondsBetween / 86400;
        
        if(numberOfDays < 0)
        {
            return  0;
        }
    }
   
    return [_perks count] -3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.button.hidden = YES;
    
    NSDictionary* perk = nil;
    
    if(_mode == kUploadVideo)
    {
        perk = [[UserAccount sharedInstance].perks objectAtIndex:indexPath.row];
        cell.button.hidden = NO;
        cell.buyButton.hidden = YES;
        cell.button.enabled = YES;
    }
    if(_mode == kEditVideo)
    {
        if([_perks count])
              perk = [_perks objectAtIndex:indexPath.row];
        cell.button.enabled = NO;
        cell.button.selected = YES;
    }
    else if(_mode == kDefault)
    {
        
        cell.buyButton.hidden = NO;
        if([[UserAccount sharedInstance].role isEqualToString:@"artist"])
        {
            PFObject *user = [_obj objectForKey:@"user"];
            
           
            if([user.objectId isEqualToString:[UserAccount sharedInstance].userid])
            {
                cell.buyButton.hidden = YES;
            }
            
            
        }
        
        if([_perks count])
            perk = [_perks objectAtIndex:indexPath.row];
      
    }
    
    cell.price.text = [NSString stringWithFormat:@"£ %.2f",[[perk objectForKey:@"price"] floatValue]];
    cell.label1.text = [perk objectForKey:@"title"];
    cell.label2.text = [perk objectForKey:@"description"];
    cell.button.tag = indexPath.row;
  
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(CustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - Notifications

- (void) videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification
{
     //XCDYouTubeVideo *video = notification.userInfo[XCDYouTubeVideoUserInfoKey];
}

- (IBAction) backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) play:(id)sender
{
    _thumbnailImageView.hidden = YES;
    
    _playButton.hidden = YES;
    
    [_videoPlayerViewController.moviePlayer play];
}

- (IBAction)buttonClicked:(id)sender
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: (int)[sender tag] inSection:0] ;
    
    
    CustomCell *cell = (CustomCell *) [_aTable cellForRowAtIndexPath:indexPath];
    cell.button.selected = !cell.button.selected;
    
    if(cell.button.selected)
    {
        [self addPerk:[sender tag]];
    }
    else
    {
        [self deletePerk:[sender tag]];
    }
}

- (void)deletePerk:(int)index
{
    [_perks removeObjectAtIndex:index];
}

- (void)addPerk:(int)index
{
    [_perks addObject:[[UserAccount sharedInstance].perks objectAtIndex:index]];
}

- (IBAction)addVideo:(id)sender
{
    [self showLoading:@""];
    
    
    NSDictionary* snippet  = [_video objectForKey:@"snippet"];
    
    NSString* title = [snippet objectForKey:@"title"];
    NSString* artist = [UserAccount sharedInstance].firstname;
    NSString* description = [snippet objectForKey:@"description"];
    NSString *url = [[[snippet objectForKey:@"thumbnails"]  objectForKey:@"medium"] objectForKey:@"url"];
    NSString* videoIdentifier = [[_video objectForKey:@"id"] objectForKey:@"videoId"];
    
    
    NSDate *expiryDate = [[NSDate date] dateByAddingTimeInterval:86400*30];
    
    
    
    

    
    //NSLog(@"video %@",video);
    [ParseAPI addDefaultPerks:nil block:^(NSMutableArray* newperks, NSError *error) {
        
       
        if (newperks != nil) {
           [_perks addObjectsFromArray:newperks];
            
            NSMutableDictionary *video = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          title, @"title",
                                          description,@"description",
                                          artist,@"artist",
                                          videoIdentifier,@"videoid",
                                          url,@"thumbnail",
                                          _perks,@"perks",
                                          expiryDate,@"expiryDate",
                                          nil];
            
            [ParseAPI addNewVideoInBackground:video block:^(BOOL succeeded, NSError *error) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
                if (succeeded) {
                    [Global sharedInstance].needRefreshFeeds = YES;
                    [Global sharedInstance].needRefreshAccount = YES;
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""                                                              message:[error localizedDescription]
                                                                     delegate:nil
                                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                            otherButtonTitles:nil];
                    [message show];
                    
                }
            }];
        }
        else
        {
            
            
        }
    }];
    
    
    
  
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
    
    if(_mode == kUploadVideo ||
       _mode == kEditVideo)
    {
        
        AddPerkViewController *vc = (AddPerkViewController*)
        [self.storyboard instantiateViewControllerWithIdentifier:@"AddPerkViewController"];
        vc.perk  = [[UserAccount sharedInstance].perks objectAtIndex:indexPath.row];
        vc.mode = kEdit;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)buyPerk:(id)sender
{
    [_videoPlayerViewController.moviePlayer pause];
    
    if(![UserAccount sharedInstance].loggedin)
    {
        
        _selectedPerk = [sender tag ];
        UINavigationController *vc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewNaviagtionController"];
        
        [self presentViewController:vc animated:NO completion:nil];
        
    }
    else
    {
        
//        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//        [currentInstallation addUniqueObject:[_obj objectForKey:@"objectId"] forKey:@"channels"];
//        [currentInstallation saveInBackground];
//
     
      

       
         BookTicketsViewController *bookTicketsViewController = (BookTicketsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BookTicketsViewController"];
         bookTicketsViewController.index = [sender tag ];
         bookTicketsViewController.obj = _obj;
        
         [self.navigationController pushViewController:bookTicketsViewController animated:YES];
   }
  
}

@end
