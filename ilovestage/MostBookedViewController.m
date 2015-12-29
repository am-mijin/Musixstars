/*
     File: MostBookedViewController.m
 Abstract: The primary view controller for this app.
 
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "MostBookedViewController.h"
#import "Cell.h"
#import "DetailsViewController.h"

#import "SWRevealViewController.h"
NSString *kDetailedViewControllerID = @"DetailsViewController";    // view controller storyboard id
NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id

@implementation MostBookedViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad
{
    
      [super viewDidLoad];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
     
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.title = @"MOST BOOKED";
    
    self.view.backgroundColor = UIColorFromRGB(0x111111);
    //self.view.backgroundColor  = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:    [NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor blackColor], NSForegroundColorAttributeName,
                                                                         [UIFont fontWithName:@"Seravek-Bold" size:23.0], NSFontAttributeName, nil]];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                         initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                         target:nil
                                         action:nil];
    [self getEvent];

}
- (void)getEvent
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"events_sample" ofType:@"plist"];
    
    
    _events = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    //NSLog(@"_events \n%@",_events);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [_events count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
   

    // make the cell's title the actual NSIndexPath value
   
    
    // load the image for this cell
    
    NSDictionary* event = [_events objectAtIndex:indexPath.row];

    cell.quantity.textColor = [UIColor blackColor];
    cell.price.textColor = [UIColor blackColor];
    cell.facevalue.textColor =[UIColor darkGrayColor];
    cell.titelLabel.textColor = [UIColor blackColor];
    cell.date.textColor = [UIColor blackColor];
    cell.timeLabel.textColor = [UIColor blackColor];
    cell.facevalue.text =[NSString stringWithFormat:@"£ %@",[[_events objectAtIndex:indexPath.row] objectForKey:@"Face Value"]];
    cell.titelLabel.text =[[_events objectAtIndex:indexPath.row] objectForKey:@"Show"];
    [cell.titelLabel sizeToFit];
    cell.titelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.titelLabel.numberOfLines = 0;
    
    cell.price.text =[NSString stringWithFormat:@"£ %@",[event objectForKey:@"Discount Price"]];
   
    NSArray* dates = [[Utilities getDateString:[[event objectForKey:@"UTC"] integerValue] format:TIMEFORMAT_TICKETS+1]  componentsSeparatedByString:@"-"];
    
    cell.date.text =  [dates objectAtIndex:1];
    cell.timeLabel.text = [dates objectAtIndex:0];
    [cell.facevalue sizeToFit];
    cell.facevalue.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.facevalue.numberOfLines = 0;
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                            100 + 15,
                                                            cell.facevalue.frame.size.width,
                                                            1)];
    line.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:line];
    cell.tag = indexPath.row;
    return cell;
}

-(IBAction)showDetails:(id)sender
{
    DetailsViewController *vc = (DetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    vc.event = [_events objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:vc animated:YES];
}

// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //if ([[segue identifier] isEqualToString:@"DetailsViewController"])
    {
        NSInteger tagIndex = [(UIButton *)sender tag];
  
        //selectedIndexPath.row
        DetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.event = [_events objectAtIndex:tagIndex];
        
       
    }
}

@end
