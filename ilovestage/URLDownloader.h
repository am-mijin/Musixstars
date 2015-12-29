//
//  URLDownloader.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol URLDownloaderDelegate ;
@interface URLDownloader : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, weak) id<URLDownloaderDelegate> delegate;
@property (nonatomic, strong) NSMutableData *results;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, readwrite) BOOL lowPriority;

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<URLDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<URLDownloaderDelegate>)delegate userInfo:(id)userInfo;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<URLDownloaderDelegate>)delegate;
- (void)start;
- (void)cancel;

@end

@protocol URLDownloaderDelegate <NSObject>

@optional
- (void)urlDownloader:(URLDownloader *)downloader didLoad:(id )result;
- (void)urlDownloader:(URLDownloader *)downloader didFinishWithImage:(UIImage *)image;
- (void)urlDownloader:(URLDownloader *)downloader didFailWithError:(NSError *)error;
@end
