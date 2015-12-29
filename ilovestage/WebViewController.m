//
//  WebViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "WebViewController.h"

#define backIndex 0
#define forwardIndex 2
#define reloadIndex 4
#define shareIndex 5

@interface WebViewController (PrivateMethods)
- (void) showLoading;
- (void) hideLoading;
@end

@implementation WebViewController
//@synthesize webView, url,activityIndicatorView,forward,back;


- (void) viewWillAppear:(BOOL)animated
{ 
      self.navigationController.navigationBar.translucent = NO;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    //[self setupBackButton];
    self.title = @"";
    [self showLoading];
  
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
    NSLog(@"%@",_url);
    [_webView loadRequest:request];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  [_webView stopLoading];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  self.navigationController.navigationBar.translucent = YES;

}

- (IBAction) goBack:sender
{
  [_webView goBack];
}

- (IBAction) goForward:sender
{
  [_webView goForward];
}

- (IBAction) reload:sender
{
  [_webView reload];
}

//- (IBAction) shareLink:sender
//{
//  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
//                                  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//  actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//  actionSheet.tag = WEBVIEW;
//  [actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", nil)];
//  [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
//  [actionSheet setCancelButtonIndex:1];
//  [actionSheet showInView:self.view];
//  [actionSheet release];
//}
//- (IBAction) back:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
#pragma mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];

  if ([title isEqualToString:NSLocalizedString(@"Cancel", nil)])
    return;

  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
  [self hideLoading];
  theWebView.backgroundColor = [UIColor whiteColor];
  
  //NSString* pageTitle = [theWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
  //self.title = pageTitle;
  _back.enabled = [theWebView canGoBack];
  _forward.enabled = [theWebView canGoForward];
}

- (void) showLoading
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  [_indicatorView setHidden:NO];
 
}

- (void) hideLoading
{
   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_indicatorView setHidden:YES];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//  return NO;
//}

- (void)viewDidLoad
{
}

#pragma mark Memory Management
- (void)viewDidUnload
{
  self.webView = nil;
}

//- (void)dealloc
//{
//  [webView release], webView = nil;
//  [activityIndicatorView release], activityIndicatorView = nil;
//  [back release],back = nil;
//  [forward release],forward = nil;
//
//  [super dealloc];
//}


@end
