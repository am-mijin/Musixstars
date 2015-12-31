//
//  BookTicketsViewController.h
//  ILOVESTAGE
//
//  Created by Mijin Cho on 05/09/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "NSString+Date.h"

@interface BookTicketsViewController :BaseViewController<RequestDelegate>
@property (strong, nonatomic) PFObject  *obj;
@property (assign) int index;
@property (assign) int type;
@end
