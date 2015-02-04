//
//  NOD.m
//  radioNOD
//
//  Created by in5630 on 11.12.14.
//  Copyright (c) 2014 zhurbenko inc. All rights reserved.
//

#import "NOD.h"
@interface NOD()


@end

@implementation NOD


- (AVAudioPlayer *)player
    NSURL *radioURL = [NSURL URLWithString:@"http://radio.rusnod.ru:8000/radio"];
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:radioURL error:&error];
    player.delegate = self;
    if (error) {
        NSLog(@"%@", error);
    } else {
        //[newPlayer release];
        [self.player prepareToPlay];
        [self.player play];
        self.playButton.enabled = NO;
        //[player setDelegate: self];
    }

@end
