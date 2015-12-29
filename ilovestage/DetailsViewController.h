//
//  DetailsViewController.h
//  ILOVESTAGE
//
//  Created by Mijin Cho on 14/08/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "consts.h"
#import "BaseViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "AVPlayerDemoPlaybackViewController.h"
@interface DetailsViewController : BaseViewController <UIScrollViewDelegate>

@property (strong, nonatomic)  PFObject *obj;
@property (readwrite, nonatomic) BOOL scrolling;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong)    UILabel  *datelabel;
@end
