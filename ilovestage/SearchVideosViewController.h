//
//  AddVideosViewController.h
//  ilovestage
//
//  Created by Mijin Cho on 31/05/2015.
//  Copyright (c) 2015 Musixstars. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "CustomCell.h"

@protocol SearchVideosDelegate <NSObject>

- (void)ShowDetails:(PFObject*)video;
@end

@interface SearchVideosViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak,nonatomic)  id <SearchVideosDelegate> delegate;

@property (strong, nonatomic)  NSMutableArray *results;
@end



