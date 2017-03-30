//
//  DragBtn.m
//  CircleProject
//
//  Created by asl on 2017/3/20.
//  Copyright © 2017年 Invisionhealth Digital Inc. All rights reserved.
//

#import "DragBtn.h"

@implementation DragBtn

@synthesize current_radian;
@synthesize current_animation_radian;
@synthesize animation_radian;
@synthesize radian;
@synthesize view_point;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
