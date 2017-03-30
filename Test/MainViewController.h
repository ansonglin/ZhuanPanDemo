//
//  MainViewController.h
//  CircleProject
//
//  Created by asl on 2017/3/20.
//  Copyright © 2017年 Invisionhealth Digital Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragImageView.h"
#import "DragBtn.h"

@interface MainViewController : UIViewController<
UIGestureRecognizerDelegate>

{
    DragBtn *imageviewBi;
    DragBtn *imageviewCustomerInfo;
    DragBtn *imageviewDesire;
    DragBtn *imageviewMyInfo;
    DragBtn *imageviewOrder;
    DragBtn *imageviewPrice;
    DragBtn *imageviewShowCar;
    
    NSMutableArray *arrImage;
    NSInteger count;
    
//    CGPoint pointCenter;
//    CGFloat fRadius;//半径
//    CGFloat fAvarage_Radina;//平均角度
//    CGPoint pointDrag;
//    NSInteger iCurrentIndex;
//    NSInteger iStep;
}





@end
