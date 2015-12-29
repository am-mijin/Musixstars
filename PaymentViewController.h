//
//  PaymentViewController.h
//  Stripe
//


#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface PaymentViewController : BaseViewController

- (IBAction)save:(id)sender;

@property (nonatomic, weak) IBOutlet UILabel *paymentinfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *billingLabel;
@property (nonatomic, weak) IBOutlet UILabel *countryLabel;
@property (nonatomic, weak) IBOutlet UITextField *postcode;

@property (nonatomic, weak) IBOutlet UIButton *saveButton;

@property (nonatomic, weak) IBOutlet UIButton *removeButton;
@end
