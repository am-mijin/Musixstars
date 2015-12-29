//
//  SDImageCacheDelegate.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "SDWebImageCompat.h"

@class SDImageCache;

@protocol SDImageCacheDelegate <NSObject>

@optional
- (void)imageCache:(SDImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info;
- (void)imageCache:(SDImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info;

@end
