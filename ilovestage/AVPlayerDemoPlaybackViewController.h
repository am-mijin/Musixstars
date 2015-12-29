//
//  AVPlayerDemoPlaybackViewController.h
//
//  Copyright (c) 2014 Rightster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "GetVideoURL.h"
#import "consts.h"
#import "config.h"
#import "AppLinkCenter.h"
#import "LoginViewController.h"

@class AVPlayer;
@class AVPlayerDemoPlaybackView;


@interface AVPlayerDemoPlaybackViewController : UIViewController <UIAlertViewDelegate>
{
@private
	

	float mRestoreAfterScrubbingRate;
	BOOL seekToZeroBeforePlay;
	id mTimeObserver;

	NSURL* mURL;
    BOOL active;
   
	AVPlayer* mPlayer;
    AVPlayerItem * mPlayerItem;
    BOOL parserDidFinish;
   
    
}
@property (nonatomic, weak)  IBOutlet UIView *logoview;
@property (weak, nonatomic) IBOutlet UIView *mNaviBar;
@property (nonatomic, strong) NSString* videourl;
@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (retain) AVPlayerItem* mPlayerItem;
@property (nonatomic, weak) IBOutlet AVPlayerDemoPlaybackView *mPlaybackView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UILabel *mDuration;
@property (nonatomic, weak) IBOutlet UILabel *mTime;
@property (nonatomic, weak) IBOutlet UIButton *mPlayButton;
@property (nonatomic, weak) IBOutlet UISlider* mScrubber;
@property (nonatomic, strong) NSURL* mURL;

- (void)showOverlayView;
- (void)hideOverlayView;
- (void)setURL:(NSURL*)URL;
- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
-(void)setup;
@end
