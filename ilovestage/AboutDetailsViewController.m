//
//  AboutDetailsViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 14/11/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "AboutDetailsViewController.h"

@interface AboutDetailsViewController ()

@end

@implementation AboutDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
//#define ABOUT_US 0
//#define TERMS_OF_USE 1
//#define PRIVACY_POLICY 2
//#define FAQ 3

    if(_mode == ABOUT_US)
    {
        
        self.title = NSLocalizedString(@"ABOUT US", @"");
    
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10,10 ,300, 300)];
        text.font =  [UIFont fontWithName:@"Seravek-Light" size:16];
        text.textColor = [UIColor blackColor];
        text.text = NSLocalizedString(@"COMPANY BIO", @"");
        [text setLineBreakMode:UILineBreakModeWordWrap];
        [text setNumberOfLines:0];
        [text sizeToFit];
        //[_scrollview addSubview:text];
    }
    else
    {
        NSString *filename = @"terms and service_ko";
  
        
        if(_mode == TERMS_OF_USE)
        {
            self.title = NSLocalizedString(@"TERMS", @"");
            filename = @"terms and service_ko";
        }
        else if(_mode == PRIVACY_POLICY)
        {
            self.title = NSLocalizedString(@"PRIVACY POLICY", @"");
            filename = @"privacy policy_ko";
        }
        else
            self.title = NSLocalizedString(@"FAQ", @"");
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, self.view.frame.size.height*20)];
        textView.font =  [UIFont fontWithName:@"Seravek-Light" size:16];
        textView.text =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        textView.scrollEnabled = NO;
        textView.editable = NO;
        textView.dataDetectorTypes = UIDataDetectorTypeLink;
        textView.tintColor = UIColorFromRGB(0x3491ed);
       
     
        textView.textColor = [UIColor blackColor];
        textView.textContainer.lineFragmentPadding = 0;
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        
        textView.delegate = self;
        //[_scrollview addSubview:textView];
        [_scrollview setContentSize: CGSizeMake(300,textView.frame.size.height)];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
    return YES;
}

@end
