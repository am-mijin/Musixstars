//
//  RegistrationViewController.m
//  ILOVESTAGE
//
//  Created by Mijin Cho on 11/09/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PaymentViewController.h"
#import "ImperialPickerController.h"

static NSString *kViewKey = @"viewKey";
@interface UserProfileViewController ()

@property (strong, nonatomic)  UIButton *rightBtn;
@property (nonatomic, strong) NSString* 	country;
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, strong)  UIView *pickerViewContainer;

@property (nonatomic, weak) IBOutlet ImperialPickerController *imperialPickerController;
@property (nonatomic, weak) IBOutlet UIView *imperialPickerViewContainer;
@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setupRightButton {
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 50, 32);
    backView.frame = _rightBtn.frame;
    _rightBtn.titleLabel.font = [UIFont fontWithName:@"Seravek" size:14];
    [_rightBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    [_rightBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
    [_rightBtn setTitle:@"Save"  forState:UIControlStateNormal];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"save_selected"] forState:UIControlStateSelected];
    [_rightBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:_rightBtn];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backView]];
    _rightBtn.enabled = NO;
   
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    //NSString *tzName = [timeZone name];
    
    self.aTable.backgroundColor = [UIColor clearColor];
    
    [self.imperialPickerController.pickerView selectRow:28 inComponent:0 animated:YES];
    
    if(self.pickerViewContainer  == nil)
        self.pickerViewContainer =[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 230)];
 
    //NSLog(@"%f,%f",self.view.frame.size.height,self.pickerViewContainer.frame.origin.y);
    _pickerViewContainer.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_pickerViewContainer];
    [_pickerViewContainer addSubview:self.imperialPickerViewContainer];
    [self.imperialPickerController setData];
    
    //[self setupRightButton];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PICKERVIEW_UPDATE object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.pickerViewContainer.frame = CGRectMake(0,320, 320, 230);
    
    //NSLog(@"%f,%f",self.view.frame.size.height,self.pickerViewContainer.frame.origin.y);
  
    
    self.navigationController.navigationBar.hidden = NO;
    
    //[UserAccount sharedInstance].loggedin = NO;

    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:NOTIFICATION_PICKERVIEW_UPDATE object:nil];
    self.firstname.attributedPlaceholder =  [[NSAttributedString alloc]
                                             initWithString:NSLocalizedString(@"FIRST NAME", @"")
                                             attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    self.title = @"MY ACCOUNT";
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"%@",currentUser[@"email"]);
        // do stuff with the user
    } else {
        // show the signup or login screen
    }
    
    if([[UserAccount sharedInstance].role isEqualToString:@"standard"])
    {
            
            
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
                                 
                                 self.mobile, kViewKey,
                                 nil],
                                
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.countrycode, kViewKey,
                                 nil],
                                
                                nil];
            
        }
        else
        {
            
            
            _dataSourceArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.firstname, kViewKey,
                                 nil],
                                
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.email, kViewKey,
                                 nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.mobile, kViewKey,
                                 nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.address, kViewKey,
                                 nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.countrycode, kViewKey,
                                 nil],
                                
                                nil];
            
            self.firstname.attributedPlaceholder =  [[NSAttributedString alloc]
                                                     initWithString:NSLocalizedString(@"AGENCY NAME", @"")
                                                     attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
        }

    
    
   
    
    
    
    self.firstname.text = [UserAccount sharedInstance].firstname;
    self.lastname.text = [UserAccount sharedInstance].lastname;
    self.email.text = [UserAccount sharedInstance].email;
    self.password.text = [UserAccount sharedInstance].password;
    self.mobile.text =  [UserAccount sharedInstance].phonenumber;
    
    self.country = [UserAccount sharedInstance].country;
    self.address.text = [UserAccount sharedInstance].address;
    self.countrycode.titleLabel.text = [UserAccount sharedInstance].countrycallingcode;
    
    
    

    [_aTable reloadData];
    
 
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
        return [_dataSourceArray count]-1;
    else if(section == 1)
        return 1;
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL addTextField = NO;
    BOOL addbutton = NO;
    BOOL alreadyAdded = NO;
    cell.textLabel.font = [UIFont fontWithName:@"Seravek" size:18];

    if(indexPath.section == 0)
    {
        if([[UserAccount sharedInstance].role isEqualToString:@"standard"])
        {
            addTextField = YES;
            
            if(indexPath.row == [self.dataSourceArray count]-2)
                addbutton = YES;
            
        }
        else{
            switch (indexPath.row) {
                case 0:
                     addTextField = YES;
                     break;
                case 1:
                     addTextField = YES;
                     break;
                case 2:
                    addbutton = YES;
                    addTextField = YES;
                    break;
                case 3:
                   
                    addTextField = YES;
                    break;
                    
                case 4:
                    addTextField = YES;
                    
                    break;
            }
            
        }
        
        if(addTextField)
        {
            UITextField *textField =  [[self.dataSourceArray objectAtIndex: indexPath.row] valueForKey:kViewKey];
            alreadyAdded = (BOOL)[cell.contentView  viewWithTag:textField.tag];
            
            
            if(!alreadyAdded)
                [cell.contentView addSubview:textField];
            
            
            
        }
        if (addbutton){
            NSString* countrycode = [NSString stringWithFormat:@"+%@" ,
                                     [UserAccount sharedInstance].countrycallingcode] ;
            UIButton* button;
            button = [[self.dataSourceArray objectAtIndex: [_dataSourceArray count]-1] valueForKey:kViewKey];
            
            [button setTitle:countrycode forState:UIControlStateNormal];
            [button setTitleColor:
             [UIColor blackColor] forState:UIControlStateNormal];
            
            if(button != nil)
                [cell.contentView addSubview:button];
        }
    
   
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = @"Payment Method";
       
        CGRect frame =CGRectMake(self.aTable.frame.size.width-30, 0, 50, 45);
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = frame;
        [button addTarget:self action:@selector(addCard:) forControlEvents:UIControlEventTouchUpInside];
        [button setTintColor:[UIColor blackColor]];
        [button setImage:[UIImage imageNamed:@"black_arrow"] forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
        
        UIImageView* backgroud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card2"]];
        backgroud.frame = CGRectMake(self.aTable.frame.size.width-50, (45-20)/2, 30, 20);
        [cell.contentView addSubview:backgroud];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 30, 10)];
        [backgroud addSubview:label];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Seravek-Light" size:10];
        if([Global sharedInstance].card.number)
        {
           
            NSString *trimmedString=[[Global sharedInstance].card.number substringFromIndex:MAX((int)[[Global sharedInstance].card.number length]-4, 0)];
            label.text = trimmedString;
          
        }
        else{
            label.text = @"";
        }
    }
    else if(indexPath.section == 2)
    {
        
        cell.textLabel.text = @"Log out";
        
        /*
        CGRect frame =CGRectMake(0, 2, 250, 42);
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = frame;
        button.titleLabel.font =  [UIFont fontWithName:@"Seravek" size:18];
    
        
        //button.backgroundColor = [UIColor clearColor];
        
        //[button addTarget:self action:@selector(selectCountryCode:) forControlEvents:UIControlEventTouchUpInside];
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitleColor:
         [UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        [button setTitle:@"Log out" forState:UIControlStateNormal];
        
        [cell.contentView addSubview:button];
        */
    }
    
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, 250, 1)];
    line.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:line];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    if(indexPath.section == 2) //logout
    {
        [self logout:nil];
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
        CGRect frame =CGRectMake(15, 0, 250, 45);
		_firstname = [[UITextField alloc] initWithFrame:frame];
		_firstname.borderStyle = UITextBorderStyleNone;
		_firstname.textColor = [UIColor blackColor];
		_firstname.font = [UIFont fontWithName:@"Seravek" size:18];
		_firstname.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"FIRST NAME", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
		_firstname.backgroundColor = [UIColor clearColor];
		_firstname.autocorrectionType = UITextAutocorrectionTypeNo;
        _firstname.tag = 1;
		_firstname.keyboardType = UIKeyboardTypeDefault;
		_firstname.returnKeyType = UIReturnKeyNext;
        _firstname.textAlignment = NSTextAlignmentLeft;
		_firstname.delegate = self;
        
        
	}
    
	return _firstname;
}

- (UITextField *)lastname
{
	if (_lastname == nil)
	{
        CGRect frame =CGRectMake(15, 0, 250, 45);
		_lastname = [[UITextField alloc] initWithFrame:frame];
		_lastname.borderStyle = UITextBorderStyleNone;
		_lastname.textColor = [UIColor blackColor];
		_lastname.font = [UIFont fontWithName:@"Seravek" size:18];
		_lastname.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"LAST NAME", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
		_lastname.backgroundColor = [UIColor clearColor];
		_lastname.autocorrectionType = UITextAutocorrectionTypeNo;
        _lastname.tag = 2;
		_lastname.keyboardType = UIKeyboardTypeDefault;
		_lastname.returnKeyType = UIReturnKeyNext;
        _lastname.textAlignment = NSTextAlignmentLeft;
		_lastname.delegate = self;
        NSLog(@"lastname");
	}
    
	return _lastname;
}

- (UITextField *)email
{
	if (_email == nil)
	{
        CGRect frame =CGRectMake(15, 0, 250, 45);
		_email = [[UITextField alloc] initWithFrame:frame];
        _email.tag = 3;
		_email.borderStyle = UITextBorderStyleNone;
		_email.textColor = [UIColor blackColor];
		_email.font = [UIFont fontWithName:@"Seravek" size:18];
        _email.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"EMAIL", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
        
		_email.backgroundColor = [UIColor clearColor];
		_email.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		_email.keyboardType = UIKeyboardTypeEmailAddress;
        // use the default type input method (entire keyboard)
		_email.returnKeyType = UIReturnKeyNext;
		
        _email.textAlignment = NSTextAlignmentLeft;
		_email.delegate = self;
    
	}
    
	return _email;
}

- (UITextField *)address
{
	if (_address == nil)
	{
        CGRect frame =CGRectMake(15, 0, 250, 45);
		_address = [[UITextField alloc] initWithFrame:frame];
        _address.tag = 1000;
		_address.borderStyle = UITextBorderStyleNone;
		_address.textColor = [UIColor blackColor];
		_address.font = [UIFont fontWithName:@"Seravek" size:18];
        _address.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"ADRESS", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
        
		_address.backgroundColor = [UIColor clearColor];
		_address.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		_address.keyboardType = UIKeyboardTypeDefault;
        // use the default type input method (entire keyboard)
		_address.returnKeyType = UIReturnKeyNext;
		
        _address.textAlignment = NSTextAlignmentLeft;
		_address.delegate = self;
        
	}
    
	return _address;
}


- (UIButton *)countrycode
{
	if (_countrycode == nil)
	{
		CGRect frame =CGRectMake(15, 0, 18*4, 45);
        _countrycode = [UIButton buttonWithType:UIButtonTypeCustom];
        _countrycode.frame = frame;
        _countrycode.titleLabel.font =  [UIFont fontWithName:@"Seravek" size:18];
        _countrycode.tag = 5;
        
     
        
        _countrycode.backgroundColor = [UIColor clearColor];
        
        //[_countrycode addTarget:self action:@selector(selectCountryCode:) forControlEvents:UIControlEventTouchUpInside];
        
        _countrycode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_countrycode setTitleColor:
        [UIColor blackColor] forState:UIControlStateNormal];
        
//        UIImageView* v = [[UIImageView alloc] initWithFrame:CGRectMake(18*3-10,
//                                                                       (45-8)/2,
//                                                                       18, 8)];
//        
//        v.image =[UIImage imageNamed:@"myaccount_phone_down"];
//        [_countrycode addSubview:v];
        
    }
    return _countrycode;
}

- (UITextField *)mobile
{
	if (_mobile == nil)
	{
        CGRect frame =CGRectMake(18*3-10+18+10+15, 0,18*9, 45);
		_mobile = [[UITextField alloc] initWithFrame:frame];
		_mobile.tag = 6;
		_mobile.borderStyle = UITextBorderStyleNone;
		_mobile.textColor = [UIColor blackColor];
		_mobile.font = [UIFont fontWithName:@"Seravek" size:18];
     
        
        _mobile.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:@"Contact Number"
         attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
        
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
        CGRect frame =CGRectMake(0, 0, 250, 45);
		_password = [[UITextField alloc] initWithFrame:frame];
		_password.tag = 8;
        _password.delegate = self;
		_password.borderStyle = UITextBorderStyleNone;
		_password.textColor = [UIColor blackColor];
		_password.font = [UIFont fontWithName:@"Seravek" size:18];
        _password.placeholder = @"Password";
        _password.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:@"PASSWORD"
         attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
        

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
        [_mobile resignFirstResponder];
        [_address resignFirstResponder];
        
        _editBtn.hidden = NO;
          [UIView animateWithDuration:0.2f animations:
             ^{
                 
                 if( self.pickerViewContainer.frame.origin.y == self.view.frame.size.height)
                 {
                   
                     
                 }
                 else
                 {
                     self.pickerViewContainer.frame = CGRectMake(0, self.view.frame.size.height, 320, self.pickerViewContainer.frame.size.height);
                   
                 }
                 
             } completion:
             ^(BOOL finished)
             {
             }];
    }
	
}

- (IBAction)selectCountryCode:(id)sender
{
   /*
    self.imperialPickerController.type = COUNTRY_CODE;
    
    [self showPickerview];
   */
    
}

- (IBAction)signup:(id)sender
{
    [self postData];
}

- (void)showPickerview
{
    [_firstname resignFirstResponder];
    [_lastname resignFirstResponder];
    [_email resignFirstResponder];
    [_password resignFirstResponder];
    [_mobile resignFirstResponder];
    [_address resignFirstResponder];
    
    [UIView animateWithDuration:0.2f animations:
     ^{
       
         if( self.pickerViewContainer.frame.origin.y == self.view.frame.size.height)
         {
          
            // [self.pickerViewContainer addSubview:self.imperialPickerViewContainer];
            // [self.imperialPickerController setData];
             
             
             self.pickerViewContainer.frame = CGRectMake(0, self.view.frame.size.height - self.pickerViewContainer.frame.size.height+20, 320, self.pickerViewContainer.frame.size.height);
            
             
             
         }
         else
         {
             self.pickerViewContainer.frame = CGRectMake(0, self.view.frame.size.height, 320, self.pickerViewContainer.frame.size.height);
             
         }
         
     } completion:
     ^(BOOL finished)
     {
         //if( self.pickerViewContainer.frame.origin.y == self.view.frame.size.height)
            // [self.imperialPickerViewContainer removeFromSuperview];
     }];


}

- (void) updateData:(NSNotification *)notification
{
    NSArray* temp = [notification.object componentsSeparatedByString:@"-"];
    if(self.imperialPickerController.type == 0)
    {
        NSString* str = [NSString stringWithFormat:@"+%@",[temp objectAtIndex:1]];
        [_countrycode setTitle:str forState:UIControlStateNormal];
        
        _country = [temp objectAtIndex:0];
    }
    else{
        //[_nationality setTitleColor:
        // [UIColor whiteColor] forState:UIControlStateNormal];
        //[_nationality setTitle:notification.object forState:UIControlStateNormal];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( self.pickerViewContainer.frame.origin.y != self.view.frame.size.height)
    {
        //[self.imperialPickerViewContainer removeFromSuperview];
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

-(void)postData
{
  
    dispatch_async(dispatch_get_main_queue(),^{
       // [self showLoading:@"Creating..."];
        
    });
    NSMutableDictionary *params = nil;
    

   

    if([[UserAccount sharedInstance].role isEqualToString:@"standard"])
    {
        
      
            
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      
                                   _firstname.text, @"firstname",
                                   _lastname.text, @"lastname",
                                   _email.text, @"strategies.local.email",
                                   _password.text, @"strategies.local.password",
                                   _mobile.text, @"contact_number",
                                   _country, @"country",
                                   [_countrycode.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""], @"countrycode",
                                   
                                   nil];
        
    }
    else{
        
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              
                  _firstname.text, @"agency_name",
                  _email.text, @"strategies.local.email",
                  _password.text, @"strategies.local.password",
                  _mobile.text, @"contact_number",
                  _country, @"country",
                  [_countrycode.titleLabel.text stringByReplacingOccurrencesOfString:@"+" withString:@""], @"countrycode",
                   _address.text, @"address",
                  
                  nil];
        
       
    }
    
    NSLog(@"params %@",params);
   
    [AppLinkCenter requestWithPath:@"v1/users"
                         andParams:params
                     andHttpMethod:@"PUT"
                       andDelegate:self];
    
 
}

-(IBAction)addCard:(id)sender
{
    
    PaymentViewController *paymentViewController = (PaymentViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    [self.navigationController pushViewController:paymentViewController animated:YES];
    
}

- (IBAction)logout:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to logout?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert show];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UserAccount sharedInstance] reset];
    
    [PFUser logOut];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

////////////////////////////////////////////////////////////////////////////////
// RequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(AppLinkCenter *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(AppLinkCenter *)request didReceiveResponse:(NSURLResponse *)response {
    
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(AppLinkCenter *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(AppLinkCenter *)request didLoad:(id)result {
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        
    });
 
    
    NSLog(@"didLoad %@",result);
    
    if (result != NULL) {
        NSDictionary * results = (NSDictionary*)result;
      
        
        if([[results objectForKey:@"status"] intValue ] == 200)
        {
            
            NSDictionary * result = [results objectForKey:@"result"];
            //[[UserAccount sharedInstance] setValue:result];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else
    {
        [self showError:@"Please try again"];
    }
    
};


/**
 * Called when an error prevents the API request from completing
 * successfully.
 */
- (void)request:(AppLinkCenter *)request didFailWithError:(NSError *)error {

    //[self hidePopup];
    [self showError:[error localizedDescription]];
    NSLog(@"didFailWithError %@" , [error localizedDescription]);
};

- (NSUInteger)supportedInterfaceOrientations {
  
    return UIInterfaceOrientationMaskPortrait;
    
}
#pragma mark -
#pragma mark === TextField Delegate ===
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
     if([[UserAccount sharedInstance].role isEqualToString:@"standard"])
     {
        if (textField == _firstname)
        {
            [_lastname becomeFirstResponder];
        }
	
        if (textField == _lastname)
        {
        
            [_email becomeFirstResponder];
		
        }
    
        if (textField == _email)
        {
        
            [_password becomeFirstResponder];
		
        }
        if (textField == _password)
        {
        
            [_mobile becomeFirstResponder];
		
        }
        if (textField == _mobile)
        {
        
            [_mobile resignFirstResponder];
		
        }
     }
    else
    {
        if (textField == _firstname)
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
        else if (textField == _mobile)
        {
            
            [_address becomeFirstResponder];
            
        }
        else if(textField == _address)
        {
            [_address resignFirstResponder];
        }
    }
	return YES;
}
@end
