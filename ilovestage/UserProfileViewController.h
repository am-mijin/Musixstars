//
//  RegistrationViewController.h
//  ILOVESTAGE
//
//  Created by Mijin Cho on 11/09/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "consts.h"
#import "config.h"
#import "BaseViewController.h"





@interface UserProfileViewController : BaseViewController<RequestDelegate,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITableView *aTable;

@property (nonatomic, strong) UITextField	*firstname;
@property (nonatomic, strong) UITextField	*lastname;
@property (nonatomic, strong) UITextField	*email;
@property (nonatomic, strong) UITextField	*password;
@property (nonatomic, strong) UITextField	*address;
@property (nonatomic, strong) UITextField	*mobile;

@property (nonatomic, strong) UIButton	*countrycode;
@property (nonatomic, weak) IBOutlet UIButton	*editBtn;
@end
