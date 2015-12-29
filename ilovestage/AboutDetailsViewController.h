//
//  AboutDetailsViewController.h
//  ilovestage
//
//  Created by Mijin Cho on 14/11/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@interface AboutDetailsViewController : BaseViewController <UITextViewDelegate>
@property(readwrite)  int mode;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@end
