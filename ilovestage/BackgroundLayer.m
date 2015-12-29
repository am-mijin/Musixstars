//
//  BackgroundLayer.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "BackgroundLayer.h"
#import "consts.h"
@implementation BackgroundLayer
+ (CAGradientLayer*) greyGradient {
    
//    UIColor *colorOne       = [UIColor colorWithWhite:0.9 alpha:1.0];
//    UIColor *colorTwo       = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
//    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
//    UIColor *colorFour      = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
//    
    UIColor *colorOne       = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];

    UIColor *colorTwo       = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];

    UIColor *colorThree     = [UIColor whiteColor];
    UIColor *colorFour      = [UIColor whiteColor];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne       = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo       = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour      = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

+ (CAGradientLayer*) blueGradient:(int)mode  {
    
    UIColor *colorOne       = [UIColor colorWithRed:100.0/255.0 green:148.0/255.0 blue:195.0/255.0 alpha:1.0];
    
    UIColor *colorTwo       = [UIColor colorWithRed:18.0/255.0 green:57.0/255.0 blue:104.0/255.0 alpha:1.0];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       
    }
    else {
        colorOne       = [UIColor colorWithRed:25.0/255.0 green:93.0/255.0 blue:165.0/255.0 alpha:1.0];
        
        colorTwo       = [UIColor colorWithRed:24.0/255.0 green:75.0/255.0 blue:130.0/255.0 alpha:1.0];
    }
    
    if(mode == TABLE_CELL_TYPE1)
    {
        colorOne       = [UIColor colorWithRed:30.0/255.0 green:74.0/255.0 blue:133.0/255.0 alpha:1.0];
        
        colorTwo       = [UIColor colorWithRed:18.0/255.0 green:54.0/255.0 blue:101.0/255.0 alpha:1.0];
        
       
    
    }
    else if(mode == TABLE_CELL_TYPE2){
        
        colorOne       = [UIColor colorWithRed:13.0/255.0 green:40.0/255.0 blue:75.0/255.0 alpha:1.0];
        
        colorTwo       = colorOne;
    }
    colorOne = [UIColor blackColor];
    colorTwo = colorOne;
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];

    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

@end
