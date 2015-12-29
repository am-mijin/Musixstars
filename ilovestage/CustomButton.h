//
//  CustomButton.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Consts.h"
@interface CustomButton : UIButton

- (void)setBackground:(UIColor*)color;
@property (nonatomic, strong) UIView *line;
@end
