//
//  DragBtn.h
//  CircleProject
//
//  Created by asl on 2017/3/20.
//  Copyright © 2017年 Invisionhealth Digital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragBtn : UIButton


//与y轴实时角度（逆时针方向），用于在拖动时候确定DragImageView的中心
@property(nonatomic) CGFloat current_radian;

//记录该位置初始的角度（与y轴）
@property(nonatomic) CGFloat radian;

//与x轴实时角度 用于DragImageView拖动停止后的旋转
@property(nonatomic) CGFloat current_animation_radian;

//记录该位置初始角度（与x轴）
@property(nonatomic) CGFloat animation_radian;

//DragImageView的中心
@property(nonatomic) CGPoint view_point;

@end
