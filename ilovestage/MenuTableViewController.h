//
//  MenuTableViewController.h
//  ilovestage
//
//  Created by Mijin Cho on 31/07/2015.
//  Copyright (c) 2015 Musixstars. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "CustomCell.h"
@interface MenuTableViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) PFObject *obj;
@end
