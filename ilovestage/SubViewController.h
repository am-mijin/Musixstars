//
//  SubViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "BaseViewController.h"

#import "CustomCell.h"
#import "config.h"
#import "consts.h"
#import "BackgroundLayer.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "UIPullToReloadTableViewController.h"
#import "NSString+Date.h"
#import "SearchVideosViewController.h"

@interface SubViewController : UIPullToReloadTableViewController<RequestDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SearchVideosDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIButton *tryagain;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic)  NSMutableArray *events;

@end
