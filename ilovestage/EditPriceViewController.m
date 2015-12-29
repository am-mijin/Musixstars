//
//  EditPriceViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 27/11/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "EditPriceViewController.h"

@interface EditPriceViewController ()

@end

@implementation EditPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.topItem.title = @"";
    
    self.title = NSLocalizedString(@"ADMIN MODE", @"");
    // Do any additional setup after loading the view.
    
   
}

-(IBAction)save:(id)sender
{
     if([_textfield.text length])
     {
         [Global sharedInstance].admin_price = _textfield.text;
    
         [self.navigationController popViewControllerAnimated:YES];
     }
     else{
         
     }
}

#pragma mark -
#pragma mark === TextField Delegate ===
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    

    if([textField.text length])
        [self save:nil];
    return YES;
}
@end
