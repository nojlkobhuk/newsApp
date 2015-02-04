//
//  NODViewController.m
//  radioNOD
//
//  Created by in5630 on 11.12.14.
//  Copyright (c) 2014 zhurbenko inc. All rights reserved.
//

#import "NODViewController.h"

@interface NODViewController ()
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, strong) AVPlayer* avplayer;
@property (nonatomic, strong) NSTimer* timer;

@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (nonatomic, retain) UILabel *duration;
//@property (retain)				CALevelMeter	*lvlMeter_in;
@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, assign) BOOL inBackground;
@property (nonatomic, strong) UIImage *pauseBtnBG;
@property (nonatomic, strong) UIImage *playBtnBG;

@end

@implementation NODViewController

@synthesize playButton;
@synthesize currentTime;
@synthesize updateTimer;
@synthesize pauseBtnBG;
@synthesize playBtnBG;
@synthesize duration;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL* url = [self oneSong];
    playBtnBG = [UIImage imageNamed:@"play.png"];
    pauseBtnBG = [UIImage imageNamed:@"pause.png"];
    AVPlayer* avplayer = [[AVPlayer alloc] initWithURL:url];
    self.avplayer = avplayer;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCurrentTimeForPlayer:(AVPlayer *)p
{
	int time = CMTimeGetSeconds(p.currentTime);
    currentTime.text = [NSString stringWithFormat:@"%d:%02d", time / 60, time % 60, nil];
}

- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:self.avplayer];
}

- (void)updateViewForPlayerState:(AVPlayer *)p
{
	[self updateCurrentTimeForPlayer:p];
    NSLog(@"update time");
	if (updateTimer)
		[updateTimer invalidate];
    
	if (p.status)
	{
		[playButton setImage:( (p.rate == 1.0) ? pauseBtnBG : playBtnBG ) forState:UIControlStateNormal];
		//[lvlMeter_in setPlayer:p];
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
	}
	else
	{
		[playButton setImage:((p.rate == 0.0) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
		//[lvlMeter_in setPlayer:nil];
		updateTimer = nil;
	}
	
}

- (void)updateViewForPlayerStateInBackground:(AVPlayer *)p
{
	[self updateCurrentTimeForPlayer:p];
	
	if (p.status)
	{
		[playButton setImage:((p.rate == 1.0) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
	}
	else
	{
		[playButton setImage:((p.rate == 0.0) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
	}
}

-(void)updateViewForPlayerInfo:(AVPlayer*)p
{
	duration.text = [NSString stringWithFormat:@"%d:%02d", (int)p.volume / 60, (int)p.volume % 60, nil];
	//progressBar.maximumValue = p.duration;
	//volumeSlider.value = p.volume;
}

- (NSURL*) oneSong {
    NSURL* url = [NSURL URLWithString:@"http://radio.rusnod.ru:8000/radio"];
    return url;
}

- (IBAction)playRadio:(UIButton *)sender
{
    if (!self.avplayer) {
        NSURL* url = [self oneSong];
        AVPlayer* avplayer = [[AVPlayer alloc] initWithURL:url];
        self.avplayer = avplayer;
        NSLog(@"init %f", self.avplayer.rate);
        //[self.avplayer play];
        self.avplayer.rate = 1.0;
        NSLog(@"play %f", self.avplayer.rate);
        [self updateViewForPlayerInfo:self.avplayer];
		[self updateViewForPlayerState:self.avplayer];
        //NSLog(@"time %lld", avplayer.currentTime.value);
    } else if (self.avplayer.rate == 1.0) {
        NSLog(@"stop");
        self.avplayer.rate = 0.0;
        [self updateViewForPlayerInfo:self.avplayer];
		[self updateViewForPlayerState:self.avplayer];
    } else {
        NSLog(@"play");
        self.avplayer.rate = 1.0;
        [self updateViewForPlayerInfo:self.avplayer];
		[self updateViewForPlayerState:self.avplayer];
    }
}

@end

