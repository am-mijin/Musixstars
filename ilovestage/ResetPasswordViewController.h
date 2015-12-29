//
//  ResetPasswordViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "consts.h"
#import "config.h"
@interface ResetPasswordViewController : BaseViewController <UITextFieldDelegate,RequestDelegate,UIAlertViewDelegate>
-(IBAction)resetPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@end
