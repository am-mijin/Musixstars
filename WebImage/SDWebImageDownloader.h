//
//  SDWebImageDownloaderDelegate.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageDownloaderDelegate.h"
#import "SDWebImageCompat.h"

extern NSString *const SDWebImageDownloadStartNotification;
extern NSString *const SDWebImageDownloadStopNotification;

@interface SDWebImageDownloader : NSObject
{
    //@private
    NSURL *url;
    SDWIWeak id<SDWebImageDownloaderDelegate> delegate;
    NSURLConnection *connection;
    NSMutableData *imageData;
    id userInfo;
    BOOL lowPriority;
    BOOL cancelled;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) id<SDWebImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, readwrite) BOOL lowPriority;
@property (nonatomic, readwrite) BOOL cancelled;

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate;
- (void)start;
- (void)cancel;
@end
