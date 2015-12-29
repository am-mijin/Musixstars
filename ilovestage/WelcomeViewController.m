//
//  WelcomeViewController.m
//  ilovestage
//
//  Created by Mijin Cho on 03/11/2014.
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
@property (strong, nonatomic)    UIVisualEffectView *effectview;
@property (strong, nonatomic)  UIImageView *background;
@property (strong, nonatomic)  UIScrollView *scrollview;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.view.backgroundColor = [UIColor blackColor];
    
    _background = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _background.image = [UIImage imageNamed:@"logo with light_cut_0"];
    
    [self.view addSubview:_background];
    [self.view sendSubviewToBack:_background];
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectview = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    _effectview.frame = _background.bounds;
    [_background addSubview:_effectview];
    _effectview.alpha= 0.0;
    
//    NSMutableArray* array = [NSMutableArray new];
    
//    for (int i=0;i <25;i++) {
//        NSString *filename =[NSString stringWithFormat:@"logo with light_cut_%d",i];
//
//        [array addObject:[UIImage imageNamed:filename]];
//    }
//    _background.animationImages = array;
  
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollview.delegate = self;
    //_scrollview.backgroundColor = [UIColor redColor];
    self.notes.frame = CGRectMake((self.view.frame.size.width-320)/2, 0, self.view.frame.size.width, self.notes.frame.size.height);
    NSLog(@"%f",self.view.frame.size.width);
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    /*
    _background.animationDuration = 0.05*25;
    _background.animationRepeatCount =1;
    [_background startAnimating];
    
  
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (0.05*25 +0.8) * NSEC_PER_SEC);
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
         _effectview.alpha= 0.0;
         [self.view addSubview:_scrollview];
         [_background setImage:[UIImage imageNamed:@"welocomenote_bg"]];
         [self.scrollview addSubview:self.notes];
         [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.notes.frame.size.height)];
         
     });
     */
    
    _effectview.alpha= 0.0;
    [self.view addSubview:_scrollview];
    [_background setImage:[UIImage imageNamed:@"welocomenote_bg"]];
    [self.scrollview addSubview:self.notes];
    [self.scrollview setContentSize:CGSizeMake(self.view.frame.size.width, self.notes.frame.size.height)];
    
    
}


-(IBAction)close:(id)sender
{
    
    [UserAccount sharedInstance].welcome = YES;
    [self dismissViewControllerAnimated:NO completion:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
/*
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        // block1
     
    });
//    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {

//    });
*/
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

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}



#pragma mark -
#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[_effectview setHidden: YES];
    
    if(scrollView.contentOffset.y < self.view.frame.size.height/2/2)
    {
        [UIView animateWithDuration:1.0f animations:
         ^{
             //_background.alpha = 1;
             _effectview.alpha = 0;
         } completion:
         ^(BOOL finished)
         {
             
             
         }];
    }
    else
    {
        [UIView animateWithDuration:1.0f animations:
         ^{
              //_background.alpha = 0;
             _effectview.alpha = 0.75;
         } completion:
         ^(BOOL finished)
         {
             
             
         }];
    }
    
}

@end
