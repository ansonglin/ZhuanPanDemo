//
//  PlayAudioTest.m
//  CircleProject
//
//  Created by asl on 2017/3/20.
//  Copyright © 2017年 Invisionhealth Digital Inc. All rights reserved.
//

#import "PlayAudioTest.h"

@implementation PlayAudioTest

+(void)playAudio:(NSString *)name
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],name];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}


@end
