//
//  HelpContentViewController.m
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "HelpContentViewController.h"

@interface HelpContentViewController ()

@end

@implementation HelpContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     
    }
    else {
        self.title = @"Help";
    }
    
	// Do any additional setup after loading the view.
    
    NSString *textPAth = [[NSBundle mainBundle] pathForResource:@"helpContent_new" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:textPAth];
    
    NSError* error = nil;
    _contents = [NSJSONSerialization
                 JSONObjectWithData:data
                 
                 options:kNilOptions
                 error:&error];

    NSArray* sections = [NSArray arrayWithObjects:@"PRODUCT OVERVIEW",
                         @"PURCHASING WatchAFL",
                         @"GENERAL HELP",
                         @"ACCOUNT CANCELLATION AND REFUNDS",
                         @"MINIMUM SYSTEM REQUIREMENTS", nil];
    

    int y = 0;
    int width = 800;
    int fontsize = 18;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
    }
    else {
        width = 300;
        fontsize = 14;
    }
    
    for (int i = 0;i<5;i++) {
        
       
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, y, width, 25)];
        header.backgroundColor = [UIColor clearColor];
        header.text = [sections objectAtIndex:i];
        header.textColor = AFL_BG_COLOR;
        header.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize+2];
        [header sizeToFit];
        [_scrollview addSubview:header];
        y  = header.frame.origin.y +header.frame.size.height+ 10;
        
        for (int j = 0;j<[[_contents objectAtIndex:i] count];j++)
        {
            NSDictionary* content = [[_contents objectAtIndex:i] objectAtIndex:j];
            
            UILabel *label = [[UILabel alloc] initWithFrame:
                              CGRectMake(0,  y , width, 25)];
            label.backgroundColor = [UIColor clearColor];
            label.text =   [content objectForKey:@"header"];
            label.textColor = SOLID_RED;
            label.numberOfLines =0;
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize];
            
            [_scrollview addSubview:label];
            [label sizeToFit];
            
            UILabel *text = [[UILabel alloc] initWithFrame:
                                    CGRectMake(0, label.frame.origin.y + label.frame.size.height + 10, width-10, 25)];
            text.numberOfLines =0;
            text.lineBreakMode = UILineBreakModeWordWrap;
            text.backgroundColor = [UIColor clearColor];
            text.text =   [content objectForKey:@"content"];
            text.textColor = [UIColor blackColor];
            text.font = [UIFont fontWithName:@"HelveticaNeue" size:fontsize-2];
        
            [_scrollview addSubview:text];
            [text sizeToFit];
            y = text.frame.origin.y + text.frame.size.height +20;
        }
        y = y + 50;
        
    }
    [_scrollview setContentSize:CGSizeMake(width, y+50)];
    
    //_header.text = [_content objectForKey:@"header"];
    //_textview.text = [_content objectForKey:@"content"];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
