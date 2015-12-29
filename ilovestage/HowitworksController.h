//
//  MyDetailsViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utilities.h"
#import "consts.h"
#import "config.h"
#import "BaseViewController.h"

@interface HowitworksController : BaseViewController <UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end
