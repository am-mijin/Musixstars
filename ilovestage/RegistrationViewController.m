//
//  RegistrationViewController.m
//  ILOVESTAGE
//
//  Created by Mijin Cho on 11/09/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ImperialPickerController.h"

#import "AddBankDetailsViewController.h"
static NSString *kViewKey = @"viewKey";
@interface RegistrationViewController ()
//@property (nonatomic, strong) NSString* 	country;
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong)  UIView *pickerViewContainer;

@property (nonatomic, weak) IBOutlet ImperialPickerController *imperialPickerController;
@property (nonatomic, weak) IBOutlet UIView *imperialPickerViewContainer;
@end

@implementation RegistrationViewController

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

    
    
    self.aTable.backgroundColor = [UIColor clearColor];
    
    //When using pickerview to selcet country codes
    /*
     
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode]; // get country code,
   
    [self.imperialPickerController setData];
    NSArray * keys=  [[[self.imperialPickerController.codeForCountryDictionary  allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] mutableCopy];
    
    
    int row = 0;
    for (NSString*  key in keys) {
        
        if([countryCode isEqualToString:[self.imperialPickerController.codeForCountryDictionary objectForKey:key]])
        {
            
            [self.imperialPickerController.pickerView selectRow:row inComponent:0 animated:NO];
            break;
        }
        row = row +1;
    }
    
    self.pickerViewContainer =[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 230)];
    _pickerViewContainer.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_pickerViewContainer];
    [_pickerViewContainer addSubview:self.imperialPickerViewContainer];
     */
  
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PICKERVIEW_UPDATE object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if( [UserAccount sharedInstance].loggedin )
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
 
    
    [self.navigationController.navigationBar setTitleTextAttributes:    [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"GothamRounded-Bold" size:18.0], NSFontAttributeName, nil]];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:NOTIFICATION_PICKERVIEW_UPDATE object:nil];
    self.firstname.attributedPlaceholder =  [[NSAttributedString alloc]
                                             initWithString:NSLocalizedString(@"FIRST NAME", @"")
                                             attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    
    if([[UserAccount sharedInstance].provider isEqualToString:@"Facebook"] ||
       [[UserAccount sharedInstance].provider isEqualToString:@"Google"] ||
         [[UserAccount sharedInstance].provider isEqualToString:@"Twitter"])
    {
        self.title =NSLocalizedString(@"SIGN UP", @"");
        
        _dataSourceArray = [NSArray arrayWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             self.firstname, kViewKey,
                             nil],
                            
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             self.lastname, kViewKey,
                             nil],
                            
                            
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             
                             self.email, kViewKey,
                             nil],
                          
                            
                          
                            
                            nil];
   
        self.firstname.text = [UserAccount sharedInstance].firstname;
        self.lastname.text = [UserAccount sharedInstance].lastname;
        self.email.text = [UserAccount sharedInstance].email;
    }
    else
    {
        if([_role isEqualToString:@"standard"])
        {
            [UserAccount sharedInstance].provider = @"";
            [UserAccount sharedInstance].provider_uid = @"";
            
            self.title =NSLocalizedString(@"SIGN UP", @"");
            
            _dataSourceArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.firstname, kViewKey,
                                 nil],
                                
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.lastname, kViewKey,
                                 nil],
                                
                                
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.email, kViewKey,
                                 nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.password, kViewKey,
                                 nil],
                               
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.promocode, kViewKey,
                                 nil],
                                
                                nil];
            
        }
        

    }
    
    self.firstname.text = @"Mijin";
    self.lastname.text = @"Cho";
    self.email.text = @"musixstarsapp@gmail.com";
    
    self.email.text = @"ikettleapp@gmail.com";
    self.password.text = @"1234";
    self.promocode.text = @"musixs";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
 
    return [_dataSourceArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
   UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    v.backgroundColor = [UIColor clearColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(25/2, 5, tableView.frame.size.width-25,40)];
    label.font = [UIFont fontWithName:@"GothamRounded-Book" size:12];
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"SIGN UP NOTE", @"");
    label.text = @"Request an invitation if you are a musicion";
    label.backgroundColor = [UIColor clearColor];
    [v addSubview:label];
    return v;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, 300, 1)];
    line.backgroundColor = UIColorFromRGB(0x413c3d);
    [cell.contentView addSubview:line];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL addTextField = NO;
    BOOL addbutton = NO;
    BOOL alreadyAdded = NO;
  

    
    if([_role isEqualToString:@"standard"])
    {
        addTextField = YES;
        

    }
    else{
        switch (indexPath.row) {
           addTextField = YES;
        }

    }
    
//    if(indexPath.row == [self.dataSourceArray count]-1)
//    {
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(25/2, 0, self.aTable.frame.size.width-25, 30)];
//        label.font = [UIFont fontWithName:@"Seravek-Light" size:12];
//        label.textColor = [UIColor lightGrayColor];
//        label.numberOfLines = 2;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"We need your contract details to notify you if an event is canceled.";
//        label.backgroundColor = [UIColor clearColor];
//         [cell.contentView addSubview:label];
//    }
    
    if(addTextField)
    {
        UITextField *textField =  [[self.dataSourceArray objectAtIndex: indexPath.row] valueForKey:kViewKey];
        alreadyAdded = (BOOL)[cell.contentView  viewWithTag:textField.tag];
        
        
        if(!alreadyAdded)
            [cell.contentView addSubview:textField];
        
    }
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

- (UITextField *)firstname
{
	if (_firstname == nil)
	{
        CGRect frame =CGRectMake(0, 0, 300, 45);
		_firstname = [[UITextField alloc] initWithFrame:frame];
		_firstname.borderStyle = UITextBorderStyleNone;
		_firstname.textColor = [UIColor whiteColor];
		_firstname.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
		_firstname.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"FIRST NAME", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
		_firstname.backgroundColor = [UIColor clearColor];
		_firstname.autocorrectionType = UITextAutocorrectionTypeNo;
        _firstname.tag = 1;
		_firstname.keyboardType = UIKeyboardTypeDefault;
		_firstname.returnKeyType = UIReturnKeyNext;
        _firstname.textAlignment = NSTextAlignmentCenter;
		_firstname.delegate = self;
        
        
	}
    
	return _firstname;
}

- (UITextField *)lastname
{
	if (_lastname == nil)
	{
        CGRect frame =CGRectMake(0, 0, 300, 45);
		_lastname = [[UITextField alloc] initWithFrame:frame];
		_lastname.borderStyle = UITextBorderStyleNone;
		_lastname.textColor = [UIColor whiteColor];
		_lastname.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
		_lastname.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"LAST NAME", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
		_lastname.backgroundColor = [UIColor clearColor];
		_lastname.autocorrectionType = UITextAutocorrectionTypeNo;
        _lastname.tag = 2;
		_lastname.keyboardType = UIKeyboardTypeDefault;
		_lastname.returnKeyType = UIReturnKeyNext;
        _lastname.textAlignment = NSTextAlignmentCenter;
		_lastname.delegate = self;
      
	}
    
	return _lastname;
}

- (UITextField *)email
{
	if (_email == nil)
	{
        CGRect frame =CGRectMake(0, 0, 300
                                 , 45);
		_email = [[UITextField alloc] initWithFrame:frame];
        _email.tag = 3;
		_email.borderStyle = UITextBorderStyleNone;
		_email.textColor = [UIColor whiteColor];
		_email.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
        _email.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"EMAIL", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        
		_email.backgroundColor = [UIColor clearColor];
		_email.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		_email.keyboardType = UIKeyboardTypeEmailAddress;
        // use the default type input method (entire keyboard)
		_email.returnKeyType = UIReturnKeyNext;
		
        _email.textAlignment = NSTextAlignmentCenter;
		_email.delegate = self;
    
	}
    
	return _email;
}


- (UITextField *)promocode
{
    if (_promocode == nil)
    {
        CGRect frame =CGRectMake(0, 0, 300, 45);
        _promocode = [[UITextField alloc] initWithFrame:frame];
        _promocode.tag = 1000;
        _promocode.borderStyle = UITextBorderStyleNone;
        _promocode.textColor = [UIColor whiteColor];
        _promocode.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
        _promocode.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"PROMOTION CODE(OPTIONAL)", @"")
         
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        
        _promocode.backgroundColor = [UIColor clearColor];
        _promocode.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
        
        _promocode.keyboardType = UIKeyboardTypeDefault;
        // use the default type input method (entire keyboard)
        _promocode.returnKeyType = UIReturnKeyDone;
        
        _promocode.textAlignment = NSTextAlignmentCenter;
        _promocode.delegate = self;
        
    }
    
    return _promocode;
}


- (UITextField *)address
{
	if (_address == nil)
	{
        CGRect frame =CGRectMake(0, 0, 300, 45);
		_address = [[UITextField alloc] initWithFrame:frame];
        _address.tag = 1000;
		_address.borderStyle = UITextBorderStyleNone;
		_address.textColor = [UIColor whiteColor];
		_address.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
        _address.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"ADDRESS", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        
		_address.backgroundColor = [UIColor clearColor];
		_address.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		_address.keyboardType = UIKeyboardTypeDefault;
        // use the default type input method (entire keyboard)
		_address.returnKeyType = UIReturnKeyNext;
		
        _address.textAlignment = NSTextAlignmentCenter;
		_address.delegate = self;
        
	}
    
	return _address;
}


- (UIButton *)countrycode
{
	if (_countrycode == nil)
	{
		CGRect frame =CGRectMake(10, 0, 18*4, 45);
        _countrycode = [UIButton buttonWithType:UIButtonTypeCustom];
        _countrycode.frame = frame;
        _countrycode.titleLabel.font =  [UIFont fontWithName:@"GothamRounded-Book" size:14];
        _countrycode.tag = 5;
        
     
        
        _countrycode.backgroundColor = [UIColor clearColor];
        
        [_countrycode addTarget:self action:@selector(selectCountryCode:) forControlEvents:UIControlEventTouchUpInside];
        
        _countrycode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_countrycode setTitleColor:
        [UIColor whiteColor] forState:UIControlStateNormal];
        
//        UIImageView* v = [[UIImageView alloc] initWithFrame:CGRectMake(18*3-10,
//                                                                       (45-8)/2,
//                                                                       18, 8)];
//        
//        v.image =[UIImage imageNamed:@"dropdown"];
//        [_countrycode addSubview:v];
        
    }
    return _countrycode;
}

- (UITextField *)mobile
{
	if (_mobile == nil)
	{
        CGRect frame =CGRectMake(18*3-10+18+10, 0,18*9, 45);
		_mobile = [[UITextField alloc] initWithFrame:frame];
		_mobile.tag = 6;
		_mobile.borderStyle = UITextBorderStyleNone;
		_mobile.textColor = [UIColor whiteColor];
		_mobile.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
     
        _mobile.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"CONTACT NUMBER", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        
		_mobile.backgroundColor = [UIColor clearColor];
        
		_mobile.keyboardType = UIKeyboardTypeNumberPad;
		_mobile.returnKeyType = UIReturnKeyNext;
		_mobile.delegate = self;
        _mobile.textAlignment = NSTextAlignmentLeft;
        
	}
	return _mobile;
}

- (UITextField *)password
{
	if (_password == nil)
	{
        CGRect frame =CGRectMake(0, 0, 300, 45);
		_password = [[UITextField alloc] initWithFrame:frame];
		_password.tag = 8;
        _password.delegate = self;
		_password.borderStyle = UITextBorderStyleNone;
		_password.textColor = [UIColor whiteColor];
		_password.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
        _password.placeholder =  NSLocalizedString(@"PASSWORD", @"");
        _password.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"PASSWORD", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        

		_password.backgroundColor = [UIColor clearColor];
		_password.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		_password.secureTextEntry = YES;
		_password.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		_password.returnKeyType = UIReturnKeyNext;
        _password.textAlignment = NSTextAlignmentCenter;
	}
    
    //NSLog(@"password %@",password.text);
    
	return _password;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [[event allTouches] anyObject];
	if ([touch view] == self.view)
	{
        [_firstname resignFirstResponder];
        [_lastname resignFirstResponder];
        [_email resignFirstResponder];
        [_password resignFirstResponder];
        [_promocode resignFirstResponder];
        
    }
}


- (IBAction)signup:(id)sender
{
    
     
    
    if(![self.email.text length]||
       ![self.firstname.text length] ||
       ![self.lastname.text length])
    {
        [self showError:NSLocalizedString(@"RegistrationError", @"")];
    }
    else{
        if([self validateEmail:self.email.text])
        {
            [self postData];
        }
        else
        {
             [self showError:NSLocalizedString(@"EamilValidataionError", @"")];
        }
    }
}



-(void)showError:(NSString*)msg
{
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}


- (void)postData
{
    
    dispatch_async(dispatch_get_main_queue(),^{
         [self showLoading:@""];
        
    });
    
    _signupBtn.enabled = NO;
    

    if([_promocode.text isEqualToString:@"AMC-7SDZ"] ||
       [_promocode.text isEqualToString:@"musixs"] )
    {
        _role = @"artist";
    }
    
    PFUser *user = [PFUser user];
    
    user.email =  _email.text;
    user.username = _email.text;
    
    
    if([_role isEqualToString:@"standard"])
    {
        if([[UserAccount sharedInstance].provider isEqualToString:@"Facebook"])
            
        {
            user.password = _firstname.text;
            user[@"role"] = @"standard";
            user[@"firstname"] = _firstname.text;
            user[@"lastname"] = _lastname.text;
            user[@"provider_uid"] = [UserAccount sharedInstance].provider_uid;
            user[@"token"] = [UserAccount sharedInstance].accessToken;
           
        }
        else
        {
            
            // other fields can be set just like with PFObject
            user.password = _password.text;
            user[@"role"] = @"standard";
            user[@"firstname"] = _firstname.text;
            user[@"lastname"] = _lastname.text;
            user[@"provider_uid"] = @"";
            user[@"token"] = @"";
        }
       
        
    }
    else
    {
        // other fields can be set just like with PFObject
        user[@"role"] = @"artist";
        user[@"firstname"] = _firstname.text;
        user[@"lastname"] = _lastname.text;
        user.password = _password.text;
        user[@"provider_uid"] = @"";
        user[@"token"] = @"";
        
    }
   
    //NSLog(@"_user %@",user);

    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [self hide];
        
        if (!error) {
            // Hooray! Let them use the app now.
            
            NSLog(@"user %@",user);
        
            [[UserAccount sharedInstance] setUser:user];
            [UserAccount sharedInstance].loggedin = YES;
            
            if( [user[@"role"] isEqualToString:@"artist"])
            {
                AddBankDetailsViewController *vc = (AddBankDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddBankDetailsViewController"];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:NO];
            }
            
        } else {
            
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            _signupBtn.enabled = NO;
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:errorString
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil]
                 show];
                
            });
            NSLog(@"error %@",errorString);
        }
    }];
}




- (NSUInteger)supportedInterfaceOrientations {
   
    return UIInterfaceOrientationMaskPortrait;
    
}

-(BOOL)shouldAutorotate
{
    return NO;
    
}

#pragma mark -
#pragma mark === TextField Delegate ===
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if([[UserAccount sharedInstance].provider isEqualToString:@"Facebook"] ||
       [[UserAccount sharedInstance].provider isEqualToString:@"Google"] ||
       [[UserAccount sharedInstance].provider isEqualToString:@"Twitter"])
    {
        if (textField == _firstname)
        {
            [_lastname becomeFirstResponder];
        }
        else if (textField == _lastname)
        {
            [_email becomeFirstResponder];
        }
        else if (textField == _email)
        {
            [_mobile becomeFirstResponder];
        }
        else if (textField == _promocode)
        {
            [_promocode resignFirstResponder];
        }

    }
    else
    {
        if (textField == _firstname)
        {
            [_lastname becomeFirstResponder];
        }
        else if (textField == _lastname)
        {
            [_email becomeFirstResponder];
        }
        else if (textField == _email)
        {
            [_password becomeFirstResponder];
        }
        else if (textField == _password)
        {
            [_mobile becomeFirstResponder];
        }
        else if (textField == _promocode)
        {
            [_promocode resignFirstResponder];
        }
    }
	return YES;
}
@end
