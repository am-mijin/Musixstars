//
//  RegistrationViewController.m


#import "AddBankDetailsViewController.h"
#import "ParseAPI.h"

static NSString *kViewKey = @"viewKey";
@interface AddBankDetailsViewController ()
@property (nonatomic, strong) NSArray *dataSourceArray;
@end

@implementation AddBankDetailsViewController

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
 
}

-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    
    _aTable.frame = CGRectMake(self.aTable.frame.origin.x,
                               0,
                               self.aTable.frame.size.width,
                               self.aTable.frame.size.height);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
 
    
    [self.navigationController.navigationBar setTitleTextAttributes:    [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"GothamRounded-Bold" size:18.0], NSFontAttributeName, nil]];
    
    
    
    
            self.title =NSLocalizedString(@"GET PAID", @"");
            
            _dataSourceArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.bankname, kViewKey,
                                 nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.accountname, kViewKey,
                                 nil],
                                
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.sortcode, kViewKey,
                                 nil],
                                
                                
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                 
                                 self.accountnumber, kViewKey,
                                 nil],
                                nil];
            
    

    
    self.bankname.text = @"Lloyds";
    self.accountname.text = @"M J CHO";
    self.sortcode.text = @"12345678";
    self.accountnumber.text = @"12345678";
   
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
  


    
    //if(addTextField)
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

- (UITextField *)bankname
{
	if (_bankname == nil)
	{
        CGRect frame =CGRectMake(0, 0, 300, 45);
		_bankname = [[UITextField alloc] initWithFrame:frame];
		_bankname.borderStyle = UITextBorderStyleNone;
		_bankname.textColor = [UIColor whiteColor];
		_bankname.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
		_bankname.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"BANK NAME", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
		_bankname.backgroundColor = [UIColor clearColor];
		_bankname.autocorrectionType = UITextAutocorrectionTypeNo;
        _bankname.tag = 1;
		_bankname.keyboardType = UIKeyboardTypeDefault;
		_bankname.returnKeyType = UIReturnKeyNext;
        _bankname.textAlignment = NSTextAlignmentCenter;
		_bankname.delegate = self;
        
        
	}
    
	return _bankname;
}

- (UITextField *)accountname
{
	if (_accountname == nil)
	{
        CGRect frame =CGRectMake(0, 0, 300, 45);
		_accountname = [[UITextField alloc] initWithFrame:frame];
		_accountname.borderStyle = UITextBorderStyleNone;
		_accountname.textColor = [UIColor whiteColor];
		_accountname.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
		_accountname.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"ACCOUNT NAME", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
		_accountname.backgroundColor = [UIColor clearColor];
		_accountname.autocorrectionType = UITextAutocorrectionTypeNo;
        _accountname.tag = 2;
		_accountname.keyboardType = UIKeyboardTypeDefault;
		_accountname.returnKeyType = UIReturnKeyNext;
        _accountname.textAlignment = NSTextAlignmentCenter;
		_accountname.delegate = self;
      
	}
    
	return _accountname;
}

- (UITextField *)sortcode
{
	if (_sortcode == nil)
	{
        CGRect frame =CGRectMake(0, 0, 300
                                 , 45);
		_sortcode = [[UITextField alloc] initWithFrame:frame];
        _sortcode.tag = 3;
		_sortcode.borderStyle = UITextBorderStyleNone;
		_sortcode.textColor = [UIColor whiteColor];
		_sortcode.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
        _sortcode.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"SORT CODE", @"")
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        
		_sortcode.backgroundColor = [UIColor clearColor];
		_sortcode.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		
		_sortcode.keyboardType = UIKeyboardTypeDefault;
        // use the default type input method (entire keyboard)
		_sortcode.returnKeyType = UIReturnKeyNext;
		
        _sortcode.textAlignment = NSTextAlignmentCenter;
		_sortcode.delegate = self;
    
	}
    
	return _sortcode;
}


- (UITextField *)accountnumber
{
    if (_accountnumber == nil)
    {
        CGRect frame =CGRectMake(0, 0, 300, 45);
        _accountnumber = [[UITextField alloc] initWithFrame:frame];
        _accountnumber.tag = 4;
        _accountnumber.borderStyle = UITextBorderStyleNone;
        _accountnumber.textColor = [UIColor whiteColor];
        _accountnumber.font = [UIFont fontWithName:@"GothamRounded-Book" size:14];
        _accountnumber.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:NSLocalizedString(@"ACCOUNT NUMBER", @"")
         
         attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
        
        _accountnumber.backgroundColor = [UIColor clearColor];
        _accountnumber.autocorrectionType = UITextAutocorrectionTypeNo;
        
        _accountnumber.keyboardType = UIKeyboardTypeDefault;
        _accountnumber.returnKeyType = UIReturnKeyDone;
        
        _accountnumber.textAlignment = NSTextAlignmentCenter;
        _accountnumber.delegate = self;
        
    }
    
    return _accountnumber;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [[event allTouches] anyObject];
	if ([touch view] == self.view)
	{
        [_bankname resignFirstResponder];
        [_accountname resignFirstResponder];
        [_sortcode resignFirstResponder];
        [_accountnumber resignFirstResponder];
    }
}

- (IBAction)save:(id)sender
{
    
     
    
    if(![self.bankname.text length]||
       ![self.accountnumber.text length] ||
       ![self.sortcode.text length] ||
       ![self.accountname.text length])
    {
        //[self showError:NSLocalizedString(@"RegistrationError", @"")];
    }
    else
    {
        [self postData];
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
 
    [self showLoading:nil];
    
    _registerBtn.enabled = NO;
    
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          _bankname.text,@"bankName",
                          _accountname.text,@"accountName",
                          _sortcode.text, @"sortCode",
                          _accountnumber.text, @"accountNumer", nil];
    
    NSLog(@"info %@",info);
    
    [ParseAPI addBankAccount:info block:^(BOOL succeeded, NSError *error) {
        [self hide];
        
        _registerBtn.enabled = NO;
        
        if (succeeded) {
            
            PFUser *currentUser = [PFUser currentUser];
            [[UserAccount sharedInstance] setUser:currentUser];
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }
        else
        {
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                NSString *errorString = [error userInfo][@"error"];
                
                NSLog(@"error %@",errorString);
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:errorString
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
                
            });
        }
    }];
    
 

}

#pragma mark -
#pragma mark === TextField Delegate ===
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == _bankname)
    {
        [_accountname becomeFirstResponder];
    }
    else if (textField == _accountname)
    {
        [_sortcode becomeFirstResponder];
    }
    else if (textField == _sortcode)
    {
        [_accountnumber becomeFirstResponder];
    }
    
	return YES;
}

@end
