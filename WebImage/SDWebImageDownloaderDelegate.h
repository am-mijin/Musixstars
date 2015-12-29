//
//  SDWebImageDownloaderDelegate.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "SDWebImageCompat.h"

@class SDWebImageDownloader;

@protocol SDWebImageDownloaderDelegate <NSObject>

@optional

- (void)imageDownloaderDidFinish:(SDWebImageDownloader *)downloader;
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image;
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error;

@end
