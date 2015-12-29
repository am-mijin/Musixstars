//
//  HelpViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface HelpViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)  NSArray *contents;
@property (weak, nonatomic) IBOutlet UITableView *aTable;
@end
