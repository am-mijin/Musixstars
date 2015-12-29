//
//  AddVideosViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 31/05/2015.
//  Copyright (c) 2015 Musixstars. All rights reserved.
//

#import "SearchVideosViewController.h"
#import "VideoDetailsViewController.h"

@interface SearchVideosViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *aTable;
@end

@implementation SearchVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _results = [NSMutableArray new];
    
    self.aTable.backgroundColor = [UIColor blackColor];
   
    self.searchBar.translucent = NO;
    self.searchBar.backgroundColor = [UIColor blackColor];
    self.searchBar.tintColor = [UIColor whiteColor];
    //UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    //txfSearchField.backgroundColor = [UIColor grayColor];
    
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"GothamRounded-Bold" size:14],
                                                                                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                 }];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        PFObject* video = [_results objectAtIndex:indexPath.row];
        
        
        NSString *url = [video objectForKey:@"thumbnail"];
        
        NSURL *thumbnailURL =  [NSURL URLWithString:url];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             cell.thumbnail.image = [UIImage imageWithData:data];
             
         }];
        
        cell.label2.text = [video objectForKey:@"title"];
        cell.label1.text = [video objectForKey:@"artist"]; //channelTitle
        cell.button.tag = indexPath.row;
        
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
    [self searchVideos];
    [self.searchBar resignFirstResponder ];
}

- (void)searchVideos
{
        PFQuery *query1 = [PFQuery queryWithClassName:@"Musixstars"];
    
        [query1 whereKey:@"title" containsString:[self.searchBar.text lowercaseString]];
    
        PFQuery *query2= [PFQuery queryWithClassName:@"Musixstars"];
        [query2 whereKey:@"artist" containsString:[self.searchBar.text uppercaseString]];
    
    
        PFQuery *mainQuery = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    
        [mainQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
            
             
             if( !error )
             {
               _results  = [objects mutableCopy];
                 NSLog(@"%@",_results);
                if([objects count] >0)
                {

                     
                }
                 
             }
             dispatch_async(dispatch_get_main_queue(),^{
                 
                 [SVProgressHUD dismiss];
                 [self.aTable setHidden:NO];
                 [self.aTable reloadData];
                 
             });
         }
         ];
}

- (IBAction) ShowDetails:(id)sender
{
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShowDetails:)]) {
        
        [self.delegate ShowDetails:[_results objectAtIndex:[sender tag]]];
    }
}
@end
