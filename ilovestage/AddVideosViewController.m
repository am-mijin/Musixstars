//
//  AddVideosViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 31/05/2015.
//  Copyright (c) 2015 Musixstars. All rights reserved.
//

#import "AddVideosViewController.h"
#import "VideoDetailsViewController.h"

NSString * const googleAPIKey = @"AIzaSyBiC9T-hQ36IZ8O50rRcNQoV5VCejy-ucw";
@interface AddVideosViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *aTable;
@property (strong, nonatomic)  NSMutableArray *results;
@end

@implementation AddVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _results = [NSMutableArray new];
    
    self.aTable.backgroundColor = [UIColor whiteColor];
    self.searchBar.translucent = NO;
    self.searchBar.backgroundColor = [UIColor blackColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"ADD VIDEO";
    
    //[self searchYouTubeVideos];
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
  
    return [_results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";

    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(_results.count > 0)
    {
        NSDictionary* video = [_results objectAtIndex:indexPath.row];
        NSDictionary* snippet= [video objectForKey:@"snippet"];
        NSString *url = [[[snippet objectForKey:@"thumbnails"]  objectForKey:@"default"] objectForKey:@"url"];
        
        NSURL *thumbnailURL =  [NSURL URLWithString:url];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             cell.thumbnail.image = [UIImage imageWithData:data];
             
         }];
        
        cell.label1.text = [snippet objectForKey:@"title"];
        cell.loved.text = [snippet objectForKey:@"channelTitle"]; //channelTitle
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

    }
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(CustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchYouTubeVideos];
    [self.searchBar resignFirstResponder ];
}

- (void)searchYouTubeVideos
{
    
    [_results removeAllObjects];
    [self showLoading:@"Loading..."];
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=0iQrkiC2byY&key=%@",
                     googleAPIKey];
    //url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@&maxResults=50&key=%@",
    //       _searchBar.text,googleAPIKey];
    
    
    url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=%@&maxResults=50&key=%@",
           _searchBar.text,googleAPIKey];
    
    url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&channelId=%@&maxResults=50&key=%@",
           @"UCmz1tgkJisjUvwZf9hAroOA",googleAPIKey];
    
    NSLog(@"search %@",url);
    
    //Formulate the string as a URL object.
    NSURL *requestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: requestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
   
}

-(void)fetchedData:(NSData *)responseData {
   
    dispatch_async(dispatch_get_main_queue(),^{
        
        [SVProgressHUD dismiss];
        
    });
    NSString* str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"results %@",str);
    //parse out the json data
    NSError* error;
    if (responseData != nil && error == nil) {
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              
                              options:kNilOptions
                              error:&error];
        
        NSLog(@"_fetchedData %@" , json );

        _results = [[json objectForKey:@"items"] mutableCopy];
        
        self.aTable.backgroundColor = [UIColor whiteColor];
        
    }
    else
    {
        
        self.aTable.backgroundColor = [UIColor clearColor];
        NSLog(@"error %@" , [error localizedDescription] );
        NSLog(@"error %@" , [error localizedDescription] );
    }
  
    [self.aTable reloadData];
    
}

- (IBAction) ShowDetails:(id)sender
{
    
    VideoDetailsViewController *vc = (VideoDetailsViewController*)
    [self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetailsViewController"];
    vc.mode = kUploadVideo;
    vc.video = [_results objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
