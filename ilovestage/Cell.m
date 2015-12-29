//
//  Cell.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "Cell.h"

#import "CustomCellBackground.h"
@implementation Cell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
        CustomCellBackground *backgroundView = [[CustomCellBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = backgroundView;
    
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titelLabel.font = [UIFont fontWithName:@"Seravek-Bold" size:24];
        self.quantity.font = [UIFont fontWithName:@"Seravek-Bold" size:20];
        self.price.font = [UIFont fontWithName:@"Seravek-Bold" size:20];
        self.facevalue.font = [UIFont fontWithName:@"Seravek-Bold" size:16];
        self.timeLabel.font = [UIFont fontWithName:@"Seravek-Bold" size:18];
        self.date.font = [UIFont fontWithName:@"Seravek-Bold" size:18];
     
   }
    return self;
}



- (void)prepareForReuse {
    [super prepareForReuse];
 
    [self setNeedsLayout];
}
@end
