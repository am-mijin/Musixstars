//
//  ParallaxCollectionViewCell.h
//  ilovestage
//
//  Created by Mijin Cho on 05/05/2015.
//  Copyright (c) 2015 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParallaxCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *thumbnail;
@property (nonatomic, strong, readonly) UILabel *price;
@property (nonatomic) CGFloat maxParallaxOffset;
@end
