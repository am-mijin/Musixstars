//
//  CustomButton.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-4, frame.size.width, 4)];
        
        [self addSubview:_line];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-4, self.frame.size.width, 4)];
        
        [self addSubview:_line];
    }
    return self;
}

- (void)setBackground:(UIColor*)color
{
    [self setBackgroundColor:color];
    _line.backgroundColor = AIBA_DARK_BLUE;
//    if(color == AIBA_RED)
//    {
//        _line.backgroundColor = AIBA_DARK_RED;
//    }
//    else if(color == AFL_BLUE){
//        
//        _line.backgroundColor = AIBA_DARK_BLUE;
//    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
