//
//  MyticketDetailsViewController.h
//  ilovestage
//
//  Created by Mijin Cho on 15/10/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MyticketDetailsViewController : BaseViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *section;
@property (weak, nonatomic) IBOutlet UILabel *bookingdetails;
@property (weak, nonatomic) IBOutlet UILabel *ticketcollection;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *totalpaid;
@property (weak, nonatomic) IBOutlet UILabel *numoftickets;
@property (weak, nonatomic) IBOutlet UILabel *bookingnumber;
@property (weak, nonatomic) IBOutlet UILabel *showname;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *venue;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *notes;
@property (weak, nonatomic) IBOutlet UILabel *ticketoffice;
@property (weak, nonatomic) IBOutlet UILabel *specialoffers;
@property (weak, nonatomic) IBOutlet UILabel *offers;
@property (weak, nonatomic) IBOutlet UILabel *ticketType;
@property (strong, nonatomic) PFObject * booking;
@property (strong, nonatomic) PFObject  *show;
@end
