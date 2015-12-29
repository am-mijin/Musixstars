//
//  HelpContentViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface HelpContentViewController : BaseViewController
@property (weak, nonatomic) NSDictionary*content;
@property(nonatomic,strong)  NSArray *contents;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@end
