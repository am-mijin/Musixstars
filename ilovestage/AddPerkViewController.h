//
//  AddPerkViewController.h
//
//  Created by Mijin Cho on 05/07/2015.
//  Copyright (c) 2015 Musixstars. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@interface AddPerkViewController :  BaseViewController<UITextFieldDelegate,UITextViewDelegate>

@property (assign) int mode;
@property (nonatomic, strong) NSMutableDictionary *perk;
@end
