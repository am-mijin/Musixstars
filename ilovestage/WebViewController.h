//
//  WebViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "consts.h"
#import "BaseViewController.h"

@interface WebViewController : BaseViewController <UIWebViewDelegate, UIActionSheetDelegate,UITextFieldDelegate>
{

}
@property (nonatomic, weak) IBOutlet UIWebView* webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* indicatorView;

@property (nonatomic, weak) IBOutlet UIButton* back;
@property (nonatomic, weak) IBOutlet UIButton* forward;
@property (nonatomic, strong) NSString* url;

- (IBAction) goBack:sender;
- (IBAction) goForward:sender;
- (IBAction) reload:sender;
- (IBAction) back:(id)sender;
@end
