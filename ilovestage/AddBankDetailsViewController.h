//
//  BankDetailsViewController.h


#import <UIKit/UIKit.h>
#import "consts.h"
#import "config.h"
#import "BaseViewController.h"





@interface AddBankDetailsViewController : BaseViewController<RequestDelegate,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITableView *aTable;

@property (nonatomic, strong) UITextField	*bankname;
@property (nonatomic, strong) UITextField	*sortcode;
@property (nonatomic, strong) UITextField	*accountnumber;
@property (nonatomic, strong) UITextField	*accountname;
@property (nonatomic, weak) IBOutlet UIButton	*registerBtn;
@end
