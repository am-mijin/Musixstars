//
//  BookTicketsViewController.m
//  ILOVESTAGE
//
//  Created by Mijin Cho on 05/09/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//
#import "PaymentViewController.h"
#import "BookTicketsViewController.h"
#import "Utilities.h"
#import <Stripe/Stripe.h>
#import "ParseAPI.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#import "Constants.h"

@interface BookTicketsViewController ()
@property (readwrite) int request;
@property (nonatomic,strong)  NSString *tokenId;

@property (nonatomic,strong)  NSString *price;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalpriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *paymentLabel;
@property (nonatomic, weak) IBOutlet UIButton *choosedateBtn;
@property (nonatomic, weak) IBOutlet UIButton *booktickets;
@property (nonatomic, weak) IBOutlet UILabel *cardnumber;
@property (readwrite) int quantity;
@property (nonatomic,strong) NSMutableDictionary *product;

@end

@implementation BookTicketsViewController
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _paymentLabel.textColor = UIColorFromRGB(0x111111);
    _product =  [[_obj objectForKey:@"perks"] objectAtIndex:_index];
    
    _price = [_product objectForKey:@"price"];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.topItem.title = @"";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-navigation"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor  whiteColor]];
    
    
    self.title = NSLocalizedString(@"BUY PERK", @"");
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    if([Global sharedInstance].card.number)
    {
        NSString *trimmedString=[[Global sharedInstance].card.number substringFromIndex:MAX((int)[[Global sharedInstance].card.number length]-4, 0)];
 
        _cardnumber.text = trimmedString;
        _cardnumber.hidden = NO;
        
    }
    else
    {
        _cardnumber.hidden = YES;
    }
    
//    if([[UserAccount sharedInstance].role isEqualToString:@"admin"])
//    {
//        _editPrice.enabled = YES;
//        if([[Global sharedInstance].admin_price length])
//           [self updatePrice];
//    }
//    else
//        _editPrice.enabled = NO;
    
//    [self updateDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) updatePrice
{
    _price =  [Global sharedInstance].admin_price;
    _totalpriceLabel.text = [NSString stringWithFormat:@"£ %.2f"
                             ,[_price floatValue ]*    _quantity ];
}


- (void) initUI
{
 

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 300, 45)];
    titleLabel.text = [NSString stringWithFormat:@"%@",
                       [_product objectForKey:@"title"]];
    
    titleLabel.font =  [UIFont fontWithName:@"GothamRounded-Bold" size:18];
    
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [titleLabel setNumberOfLines:0];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    [titleLabel setFrame:CGRectMake(10,  titleLabel.frame.origin.y,
                                    300, 50)];
    [self.view addSubview:titleLabel];
  
    NSLog(@"%f",titleLabel.frame.size.height);
    //[self updateDate];
  
    _totalpriceLabel.text = [NSString stringWithFormat:@"£ %.2f",
                             [_price floatValue ] ];
   
    

}


-(IBAction)addCard:(id)sender
{
    PaymentViewController *paymentViewController = (PaymentViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
         [self.navigationController pushViewController:paymentViewController animated:YES];
    
}

-(IBAction)chooseDate:(id)sender
{
    
  
}



- (void)hasError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)hasToken:(STPToken *)token
{
   
    _tokenId = token.tokenId;

    
    NSMutableDictionary *orderinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         _product, @"perk",
                                         [NSNumber numberWithInt:_index], @"index",
                                         _addressLabel.text, @"orderinfo",
                                        nil];
   
    NSLog(@"order %@",orderinfo);
    
    [ParseAPI orderPerkInBackground:_obj order:orderinfo block:^(NSString* bookingid, NSError *error) {
        
        if (bookingid) {
            int amount = [_price floatValue ]*1*1.634*100;
            amount = [_price floatValue ]*1*100;
            NSString * amountstr = [NSString stringWithFormat:@"%d",amount];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            NSNumber *total = [formatter numberFromString:amountstr];
            NSLog(@"%d",amount);
            
            NSString* description = [NSString stringWithFormat:@"%@\n%@",
                                     [_obj objectForKey:@"title"],
                                     [_product objectForKey:@"title"]];
            
            NSMutableDictionary *chargeParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 _tokenId, @"token",
                                                 @"GBP", @"currency",
                                                 bookingid,@"bookingid",
                                                 total, @"amount",
                                                 @"STPCard", @"processor",
                                                 @"Musixstars Ltd", @"statement_description",                                            description, @"description",
                                                 [UserAccount sharedInstance].email
                                                 ,@"receipt_email",
                                                 nil];
            NSLog(@"__chargeParams %@",chargeParams);
            [PFCloud callFunctionInBackground:@"charge" withParameters:chargeParams block:^(id object, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error) {
                    [self hasError:error];
                    return;
                }
                
                // There was a problem, check error.description
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    
                                                    [_product objectForKey:@"title"] ,@"title",
                                                    [_product objectForKey:@"price"] ,@"price",
                                                         nil];
                    
                    [self sendNotification:info];
                    
                    [Global sharedInstance].last_updated_time = 0;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your booking has been reserved!"
                                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    
                    [alert show];
                    
                });
            }];
            //[[Global sharedInstance].feeds replaceObjectAtIndex:[sender tag] withObject:video];
            
        }
        else
        {
            
        }
    }];
    
    
    
}

-(void)sendNotification:(NSDictionary* )info
{
    
    
    PFUser *user = [_obj objectForKey:@"user"];
    NSMutableArray*recipients = [[NSMutableArray alloc]  initWithObjects:user.objectId, nil];
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" containedIn:recipients];
    
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    
    NSString* messageContent = [NSString stringWithFormat:@"%@ sponsored £ %.2f!!",
                         [UserAccount sharedInstance].firstname,
                         [[info objectForKey:@"price"] floatValue]];
    
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          messageContent, @"alert",
                          @"Increment", @"badge",
                          nil];
    
    //[push setMessage:message];
    
    [push setData:data];
    [push sendPushInBackground];
    
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [Global sharedInstance].curMenu = MYACCOUNT;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(IBAction)makePayment:(id)sender
{
    //_dateLabel.text = @"23 Mar 2015";
    //_timeLabel.text = @"19:30";
    
    
    /*if([_dateLabel.text isEqualToString:@"Delivery Date"])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                          message:@"Please choose a delivery date"
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
     
    }*/
    //else
    {
        //[self addtoMytickets];
        //[self.navigationController popViewControllerAnimated:YES];
        
        /*
         Your booking is confirmed!
         Billy Elliot
         at Victoria Place
         01 Nov 2014 at 19:30
         */
        
        /*
         PFInstallation *installation = [PFInstallation currentInstallation];
         [installation setObject:@"123456" forKey:@"bookingid"];
         [installation setObject:@"542d68d2564d85a004f596fa" forKey:@"userid"];
         //[installation setObject:[UserAccount sharedInstance].userid forKey:@"userid"];
         [installation saveInBackground];
         */
        
         /*
         // Send a notification to all devices subscribed to the "Giants" channel.
         PFPush *push = [[PFPush alloc] init];
         [push setChannel:@"Giants"];
         [push setMessage:@"The Giants just scored!"];
         [push sendPushInBackground];
         
         // When users indicate they are no longer Giants fans, we unsubscribe them.
         PFInstallation *currentInstallation = [PFInstallation currentInstallation];
         [currentInstallation removeObject:@"Giants" forKey:@"channels"];
         [currentInstallation saveInBackground];
         */
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        _booktickets.enabled = NO;
        /*
        STPCard *card = [[STPCard alloc] init];
        card.number = [Global sharedInstance].card.number;
        card.expMonth = [Global sharedInstance].card.expMonth;
        card.expYear = [Global sharedInstance].card.expYear;
        card.cvc = [Global sharedInstance].card.cvc;
        card.addressZip = [Global sharedInstance].card.addressZip;
        card.addressCountry  = [Global sharedInstance].card.addressCountry;
        
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [Stripe createTokenWithCard:card completion:^(STPToken *token, NSError *error) {
            
            if (error) {
                [self hasError:error];
            } else {
                [Global sharedInstance].card = card;
                [self hasToken:token];
            }
        }];*/
        
        NSLog(@"%d %d",[Global sharedInstance].card.number,
              [Global sharedInstance].card.expYear);
        [[STPAPIClient sharedClient] createTokenWithCard: [Global sharedInstance].card
                                              completion:^(STPToken *token, NSError *error) {
                                                  
                                                  if (error) {
                                                      [self hasError:error];
                                                      return ;
                                                  }
                                                  /*
                                                  [self createBackendChargeWithToken:token
                                                                                         completion:^(STPBackendChargeResult result, NSError *error) {
                                                                                             if (error) {
                                                                                                 
                                                                                                 [self hasError:error];
                                                                                                 return;
                                                                                             }
                                                                                             [self hasToken:token];
                                                                                         }];*/
                                                  
                                                    [self hasToken:token];
                                              }];
        
    }
}

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    
    if (!BackendChargeURLString) {
        NSError *error = [NSError
                          errorWithDomain:StripeDomain
                          code:STPInvalidRequestError
                          userInfo:@{
                                     NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Good news! Stripe turned your credit card into a token: %@ \nYou can follow the "
                                                                 @"instructions in the README to set up an example backend, or use this "
                                                                 @"token to manually create charges at dashboard.stripe.com .",
                                                                 token.tokenId]
                                     }];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *urlString = [BackendChargeURLString stringByAppendingPathComponent:@"charge"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postBody = [NSString stringWithFormat:@"stripeToken=%@&amount=%@", token.tokenId, @1000];
    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                          if (!error && httpResponse.statusCode != 200) {
                                                              error = [NSError errorWithDomain:StripeDomain
                                                                                          code:STPInvalidRequestError
                                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
                                                          }
                                                          if (error) {
                                                              completion(STPBackendChargeResultFailure, error);
                                                          } else {
                                                              completion(STPBackendChargeResultSuccess, nil);
                                                          }
                                                      }];
    
    [uploadTask resume];
}

@end
