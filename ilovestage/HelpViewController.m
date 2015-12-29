//
//  HelpViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "HelpViewController.h"

#import "BackgroundLayer.h"
#import "CustomCell.h"
#import "HelpContentViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
 

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *textPAth = [[NSBundle mainBundle] pathForResource:@"helpContent_new" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:textPAth];
    
    NSError* error = nil;
     _contents = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
   
    
    
   
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [[_contents objectAtIndex:section] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient:TABLE_SECTION];
    bgLayer.frame = v.bounds;
    [v.layer insertSublayer:bgLayer atIndex:0];
    
    
    UILabel* label =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    label.textAlignment = UITextAlignmentCenter;
  
    NSArray* sections = [NSArray arrayWithObjects:@"PRODUCT OVERVIEW",
                         @"PURCHASING WatchAFL",
                         @"GENERAL HELP",
                         @"ACCOUNT CANCELLATION AND REFUNDS",
                         @"MINIMUM SYSTEM REQUIREMENTS", nil];
    
 
    label.text = [sections objectAtIndex:section];
    
    [v addSubview:label];
    
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }


    // Configure the cell...
    cell.label1.text = [[[_contents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectForKey:@"header"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [_aTable indexPathForSelectedRow];
    
    NSDictionary* content = [[_contents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    HelpContentViewController*vc = (HelpContentViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HelpContentViewController"];
    vc.content = content;
    [self.navigationController pushViewController:vc animated:YES];
   

}



@end
