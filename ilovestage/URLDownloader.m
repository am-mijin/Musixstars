//
//  URLDownloader.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "URLDownloader.h"

@interface URLDownloader ()
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation URLDownloader
@synthesize url, delegate = _delegate, connection, results, userInfo, lowPriority;

#pragma mark Public Methods

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<URLDownloaderDelegate>)delegate
{
    return [self downloaderWithURL:url delegate:delegate userInfo:nil];
}

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<URLDownloaderDelegate>)delegate userInfo:(id)userInfo
{
    return [self downloaderWithURL:url delegate:delegate userInfo:userInfo lowPriority:NO];
}

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<URLDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority
{
    URLDownloader *downloader = [[URLDownloader alloc] init];
    downloader.url = url;
    downloader.delegate = delegate;
    downloader.userInfo = userInfo;
    downloader.lowPriority = lowPriority;
    
    [downloader performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:YES];
    return downloader;
}

- (void)start
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url 
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                              timeoutInterval:15];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    if (!lowPriority)
    {
        [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    [connection start];
    
    
    if (connection)
    {
        self.results = [NSMutableData data];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(urlDownloader:didFailWithError:)])
        {
            [self.delegate performSelector:@selector(urlDownloader:didFailWithError:) withObject:self withObject:nil];
        }
    }
}

- (void)cancel
{ 
    if (connection)
    {
        [connection cancel];
    }
}

#pragma mark NSURLConnection (delegate)

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
    [self.results appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    //NSLog(@"connectionDidFinishLoading");
    if ([self.delegate respondsToSelector:@selector(urlDownloader:didFinishWithImage:)])
    {
        UIImage *image = [[UIImage alloc] initWithData:self.results];
        
        [self.delegate performSelector:@selector(urlDownloader:didFinishWithImage:) withObject:self withObject:image];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoad:)])
    {
        NSError* error = nil;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:self.results
                              
                              options:kNilOptions
                              error:&error];
        id result = json;

        

        [self.delegate performSelector:@selector(didLoad:) withObject:result];
    }
    self.results = nil;
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(urlDownloader:didFailWithError:)])
    {
        [self.delegate performSelector:@selector(urlDownloader:didFailWithError:) withObject:self withObject:error];
    }
    
    self.connection = nil;
    self.results = nil;
}

@end
