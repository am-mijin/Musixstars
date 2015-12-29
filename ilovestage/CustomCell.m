//
//  CustomCell.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.label1.font = [UIFont fontWithName:@"Seravek-Bold" size:20];
        
        self.label2.font = [UIFont fontWithName:@"Seravek-Bold" size:14];
        self.price.font = [UIFont fontWithName:@"Seravek-Bold" size:18];
        //self.facevalue.font = [UIFont fontWithName:@"Seravek-Bold" size:14];
        self.quantity.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.date.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        //self.location.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
