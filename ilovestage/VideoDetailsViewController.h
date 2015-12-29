//
//  VideoDetailsViewController.h
//  ilovestage
//
//  Created by Mijin Cho on 03/06/2015.
//  Copyright (c) 2015 Musixstars. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
@interface VideoDetailsViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (assign)  int mode;
@property (strong, nonatomic)  NSDictionary *video;
@property (strong, nonatomic)  PFObject *obj;
@property (strong, nonatomic)  IBOutlet UITableView*aTable;
@end
