//
//  AddPerkViewController.m
//
//  Created by Mijin Cho on 05/07/2015.
//  Copyright (c) 2015 Musixstars. All rights reserved.
//

#import "AddPerkViewController.h"
#import "ParseAPI.h"

@interface AddPerkViewController ()

@property (nonatomic, weak) IBOutlet UITextView	*titleTextView;
@property (nonatomic, weak) IBOutlet UITextView	*descTextView;
@property (nonatomic, weak) IBOutlet UITextField	*priceTextField;

@property (nonatomic, weak) IBOutlet UIButton	*shippingAddressBtn;
@property (nonatomic, weak) IBOutlet UIButton	*button;

@end

@implementation AddPerkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xebebeb);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(_mode == kEdit)
    {
        self.title = NSLocalizedString(@"PERK", @"");
        _titleTextView.text = [_perk objectForKey:@"title"];
        _descTextView.text = [_perk objectForKey:@"description"];
        _priceTextField.text = [NSString stringWithFormat:@"%.2f",[[_perk objectForKey:@"price"] floatValue]];
       
        _button.hidden = YES;
        _titleTextView.editable = NO;
        _descTextView.editable = NO;
        _priceTextField.enabled = NO;
    }
    else
    {
       self.title = NSLocalizedString(@"ADD PERK", @"");
      
        _titleTextView.text = @"Ringtons”";
        _descTextView.text = @"You will receive ringtone for you smartphone.";
        _priceTextField.text = @"5.00";
//        
//        _titleTextView.text = @"Shout Out - “Thank You”";
//        _descTextView.text = @"Receive a “thank-you” shout out via social media!";
//        _priceTextField.text = @"1.00";
        
        _button.hidden = NO;
        [_button setTitle:@"Add Perk" forState:UIControlStateNormal];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)savePerks
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[UserAccount sharedInstance].perks forKey:@"perks"];
    
    [defaults synchronize];
}

- (IBAction)requireShippingAddress:(id)sender
{
    _shippingAddressBtn.selected = !
    _shippingAddressBtn.selected;
}

- (IBAction)addPerk:(id)sender
{
    [self showLoading:@""];
    NSString* title = _titleTextView.text;
    NSString* price = _priceTextField.text;
    NSString* description = _descTextView.text;
    
    if(title.length && price.length && description.length)
    {
        NSMutableDictionary *perk = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithFloat:[price floatValue]], @"price",
                                     title, @"title",
                                     description,@"description",
                                     @"",@"expirydate",
                                     [NSNumber numberWithInt:0],@"total",
                                     _shippingAddressBtn.selected?[NSNumber numberWithBool:YES]:[NSNumber numberWithBool:NO],@"delivery",
                                     nil];
        
        [ParseAPI addNewPerkInBackground:perk block:^(BOOL succeeded, NSError *error) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
            if (succeeded) {
                
                [self savePerks];
                [self.navigationController popViewControllerAnimated:YES];
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
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""                                                              message:@"Please enter information"
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
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
#pragma mark -
#pragma mark === TextField Delegate ===
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
}

#pragma mark -
#pragma mark === TextView Delegate ===
#pragma mark -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
   
    if ([touch view] == self.view)
    {
        [_priceTextField resignFirstResponder];
        [_titleTextView resignFirstResponder];
        [_descTextView resignFirstResponder];
    }
    
}

@end
