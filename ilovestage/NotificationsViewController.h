//
//  MyticketsViewController.h
//  ilovestage
//
//  Created by Mijin Cho on 26/09/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "CustomCell.h"
#import "UIPullToReloadTableViewController.h"


@interface NotificationsViewController : UIPullToReloadTableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *signinBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
