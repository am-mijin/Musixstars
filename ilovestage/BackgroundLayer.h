//
//  BackgroundLayer.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BackgroundLayer : NSObject
+(CAGradientLayer*) greyGradient;
+(CAGradientLayer*) blueGradient:(int)mode;

@end
