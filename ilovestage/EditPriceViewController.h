//
//  EditPriceViewController.h
//  ilovestage
//
//  Created by Mijin Cho on 27/11/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface EditPriceViewController : BaseViewController <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *textfield;
@end
