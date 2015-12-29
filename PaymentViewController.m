//
//  PaymentViewController.m
//
//


#import <Stripe/Stripe.h>
#import "MBProgressHUD.h"
#import "PaymentViewController.h"
//#import "PTKView.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface PaymentViewController ()<STPPaymentCardTextFieldDelegate>

@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@end

@implementation PaymentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =NSLocalizedString(@"PAYMENT METHOD", @"");
 
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
      self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    STPPaymentCardTextField *paymentTextField = [[STPPaymentCardTextField alloc] init];
    paymentTextField.delegate = self;
    self.paymentTextField = paymentTextField;
    [self.view addSubview:paymentTextField];
    
    _saveButton.enabled = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat padding = 15;
    CGFloat width = CGRectGetWidth(self.view.frame) - (padding * 2);
    self.paymentTextField.frame = CGRectMake(padding, padding, width, 55);
    
    self.paymentTextField.frame = CGRectMake(15, 40, width, 44);
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor  blackColor]];
    
    if([[Global sharedInstance].card.number length])
    {
        _postcode.text = [Global sharedInstance].card.addressZip;
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor  blackColor]];
    _postcode.text = @"N5 2AB";
    
    [ self.paymentTextField resignFirstResponder];
    [self initUI];
}

-(void)initUI
{
    _saveButton.enabled = NO;
    
    if([[Global sharedInstance].card.number length])
    {
        _removeButton.hidden = NO;
    }
    else
        _removeButton.hidden = YES;
}


- (IBAction)removeCard:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to remove this card?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Remove", nil];
    
    [alert show];
}

- (IBAction)save:(id)sender {
    
    
    if (![_postcode.text length]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Billing Address"
                                                          message:@"Please enter your postcode."
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    if (![self.paymentTextField isValid]) {
        return;
    }
 
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    STPCardParams *card =  self.paymentTextField.card;
    
    
    card.addressZip = _postcode.text;
    card.addressCountry  = _countryLabel.text;
    
    [Global sharedInstance].card = card;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
    if(textField.isValid)
    {
        _saveButton.enabled = YES;
    }
    else
    {
        
        _saveButton.enabled = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [[event allTouches] anyObject];
	
	
	if ([touch view] == self.view)
	{
        [_postcode resignFirstResponder];
        
        [ self.paymentTextField resignFirstResponder];
        
    
	}
	
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [Global sharedInstance].card.number = @"";
    
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app save];
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
