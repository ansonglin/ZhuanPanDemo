//
//  CircleView.m
//  CircleProject
//
//  Created by zbq on 13-10-31.
//  Copyright (c) 2013年 zbq. All rights reserved.
//

#import "CircleView.h"
#import "DragImageView.h"
#import "DragBtn.h"
#import "PlayAudioTest.h"

@interface CircleView ()
- (void)showImage;
- (CGFloat)getRadinaByRadian:(CGFloat)radian;
- (void)addGesture;
- (void)handleSinglePan:(id)sender;
- (void)dragPoint:(CGPoint)dragPoint movePoint:(CGPoint)movePoint centerPoint:(CGPoint)centerPoint;
- (void)reviseCirclePoint;
- (void)animateWithDuration:(CGFloat)time animateDelay:(CGFloat)delay changeIndex:(NSInteger)change_index toIndex:(NSInteger)to_index circleArray:(NSMutableArray *)array clockwise:(BOOL)is_clockwise;

@property (nonatomic, strong) DragBtn *mainview;

@end

@implementation CircleView

@synthesize arrImages;
@synthesize mainview;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
    }
    return self;
}

- (void)loadView{
    if (arrImages.count > 0) {
        [self addGesture];
        [self showImage];
        
    }else{
        return;
    }
}

/*
显示圆环
显示方式是确定圆心正下方的点，然后逆时针绘制点
 */
- (void)showImage{
    self.backgroundColor = [UIColor clearColor];
    CGFloat fRadina;//与y轴的夹角
    average_radina = 2*M_PI/arrImages.count;
    DragBtn *dragImageView = [arrImages objectAtIndex:0];
    CGFloat width = dragImageView.frame.size.width;
    CGFloat heigh = dragImageView.frame.size.height;
    //计算半径
    radius = MIN(self.frame.size.width-width, self.frame.size.height-heigh)/2.5;
    for (int i=0; i<arrImages.count; i++) {
        fRadina = [self getRadinaByRadian:i*average_radina];
        CGPoint point = [self getPointByRadian:fRadina centreOfCircle:center radiusOfCircle:radius];
        mainview = [arrImages objectAtIndex:i];
        mainview.center = point;
        mainview.current_radian = fRadina;
        mainview.radian = fRadina;
        mainview.view_point = point;
        mainview.current_animation_radian = [self getAnimationRadianByRadian:fRadina];
        mainview.animation_radian = [self getAnimationRadianByRadian:fRadina];
        [self addSubview:mainview];
    }
#warning 根据Y值来判断当前按钮的具体位置
    for (UIButton * butt in arrImages) {
        
        int min = 1000;
        for (int i = 0; i < arrImages.count; i++) {
            
            UIButton *but1 = arrImages[i];
            if (min > but1.frame.origin.y) {
                min = but1.frame.origin.y;
            }
        }
        if (butt.frame.origin.y == min ) {
            count = butt.tag;
           // 注册通知来实现当前出现在最上方的按钮，记录其tag值
            [[NSNotificationCenter defaultCenter] postNotificationName:@"currentCount" object:self userInfo:@{@"count":[NSNumber numberWithInteger:butt.tag]}];
        }
    }
    
    
    
    
    
    
    
}

//计算线与y轴的夹角,确保在0～2*M_PI之间
- (CGFloat)getRadinaByRadian:(CGFloat)radian
{
    if(radian > 2 * M_PI)//floorf表示不大于该数的最大整数
        return (radian - floorf(radian / (2.0f * M_PI)) * 2.0f * M_PI);
    
    if(radian < 0.0f)//ceilf表示不小于于该数的最小整数
        return (2.0f * M_PI + radian - ceilf(radian / (2.0f * M_PI)) * 2.0f * M_PI);
    return radian;
}

//根据夹角（与y轴），中心点，半径就出点坐标
- (CGPoint)getPointByRadian:(CGFloat)radian centreOfCircle:(CGPoint)circle_point radiusOfCircle:(CGFloat)circle_radius
{
    CGFloat c_x = sinf(radian) * circle_radius + circle_point.x;
    CGFloat c_y = cosf(radian) * circle_radius + circle_point.y;
    
    return CGPointMake(c_x, c_y);
}

//根据和y轴的夹角换算成与x轴的夹角用于拖动后旋转
- (CGFloat)getAnimationRadianByRadian:(CGFloat)radian
{
    
    CGFloat an_r = 2.0f * M_PI -  radian + M_PI_2;
    
    if(an_r < 0.0f)
        an_r =  - an_r;
    
    return an_r;
}

/*
 添加手势
 */
- (void)addGesture{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSinglePan:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
    [panGesture release];
}

//手势操作
- (void)handleSinglePan:(id)sender{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)sender;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            pointDrag = [panGesture locationInView:self];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint pointMove = [panGesture locationInView:self];
            [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
            pointDrag = pointMove;
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint pointMove = [panGesture locationInView:self];
            [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
            [self reviseCirclePoint];
            
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            CGPoint pointMove = [panGesture locationInView:self];
            [self dragPoint:pointDrag movePoint:pointMove centerPoint:center];
            [self reviseCirclePoint];
            
        }
            break;
            
        default:
            break;
    }
}

// 随着拖动改变子view位置，子view与y轴的夹角，子view与x轴的夹角
- (void)dragPoint:(CGPoint)dragPoint movePoint:(CGPoint)movePoint centerPoint:(CGPoint)centerPoint{
    CGFloat drag_radian   = [self schAtan2f:dragPoint.x - centerPoint.x theB:dragPoint.y - centerPoint.y];
    
    CGFloat move_radian   = [self schAtan2f:movePoint.x - centerPoint.x theB:movePoint.y - centerPoint.y];
    
    CGFloat change_radian = (move_radian - drag_radian);
    for (int i=0; i<arrImages.count; i++) {
        DragBtn *imageview = [arrImages objectAtIndex:i];
        imageview.center = [self getPointByRadian:(imageview.current_radian+change_radian) centreOfCircle:center radiusOfCircle:radius];
        imageview.current_radian = [self getRadinaByRadian:imageview.current_radian + change_radian];
        imageview.current_animation_radian = [self getAnimationRadianByRadian:imageview.current_radian];
    }
}

//计算schAtan值
- (CGFloat)schAtan2f:(CGFloat)a theB:(CGFloat)b
{
    CGFloat rd = atan2f(a,b);
    
    if(rd < 0.0f)
        rd = M_PI * 2 + rd;
    
    return rd;
}

//旋转结束后滑动到指定位置
- (void)reviseCirclePoint{
    BOOL isClockwise;
    
    DragBtn *imageviewFirst = [arrImages objectAtIndex:0];
    CGFloat temp_value = [self getRadinaByRadian:imageviewFirst.current_radian]/average_radina;
    NSInteger iCurrent = (NSInteger)(floorf(temp_value));
    temp_value = temp_value - floorf(temp_value);
    
    step = iCurrent;
    if (temp_value > 0.5f) {//超过半个弧度
        isClockwise = NO;
        step ++;
    }else{
        isClockwise = YES;
    }
    
    for (int i=0; i<arrImages.count; i++) {
        NSInteger iDest = i+step;
        if (iDest >= arrImages.count) {
            iDest = iDest%arrImages.count;
        }
        [self animateWithDuration:0.25f * (temp_value/average_radina)  animateDelay:0.0f changeIndex:i toIndex:iDest circleArray:arrImages clockwise:isClockwise];
    }
    
    [PlayAudioTest playAudio:@"iPod Click.aiff"];//播放声音

}

//平衡动画
- (void)animateWithDuration:(CGFloat)time animateDelay:(CGFloat)delay changeIndex:(NSInteger)change_index toIndex:(NSInteger)to_index circleArray:(NSMutableArray *)array clockwise:(BOOL)is_clockwise{
    DragBtn *change_cell = [array objectAtIndex:change_index];
    DragBtn *to_cell     = [array objectAtIndex:to_index];
    
    /*圆*/
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:[NSString stringWithFormat:@"position"]];
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,change_cell.layer.position.x,change_cell.layer.position.y);
    
    int clockwise = is_clockwise?0:1;
    
	CGPathAddArc(path,nil,
                 center.x, center.y, /*圆心*/
                 radius,                          /*半径*/
                 change_cell.current_animation_radian, to_cell.animation_radian, /*弧度改变*/
                 clockwise
                 );
	animation.path = path;
	CGPathRelease(path);
    animation.fillMode            = kCAFillModeForwards;
	animation.repeatCount         = 1;
    animation.removedOnCompletion = NO;
 	animation.calculationMode     = @"paced";
    
    /*动画组合*/
    CAAnimationGroup *anim_group  = [CAAnimationGroup animation];
    anim_group.animations          = [NSArray arrayWithObjects:animation, nil];
    anim_group.duration            = time + delay;
    anim_group.delegate            = self;
    anim_group.fillMode            = kCAFillModeForwards;
    anim_group.removedOnCompletion = NO;
    
    [change_cell.layer addAnimation:anim_group forKey:[NSString stringWithFormat:@"anim_group_%ld",(long)change_index]];
    
    /*改变属性*/
    change_cell.current_animation_radian = to_cell.animation_radian;
    change_cell.current_radian           = to_cell.radian;
    
    
    
}

#pragma mark -
#pragma mark - animation delegate

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    for (int i = 0; i < arrImages.count; ++i)
    {
        NSInteger iDest = i+step;
        if (iDest >= arrImages.count) {
            iDest = iDest%arrImages.count;
        }
        DragBtn *change_cell = [arrImages objectAtIndex:i];
        
        DragBtn *to_cell = [arrImages objectAtIndex:iDest];
        
        [change_cell.layer removeAllAnimations];
        
        change_cell.center = to_cell.view_point;
        
    }
    
#warning 根据Y值来判断当前按钮的具体位置在每次转动结束时
    for (UIButton * butt in arrImages) {
        
        int min = 1000;
        for (int i = 0; i < arrImages.count; i++) {
            
            UIButton *but1 = arrImages[i];
            if (min > but1.frame.origin.y) {
                min = but1.frame.origin.y;
            }
        }
        if (butt.frame.origin.y == min ) {
            // 注册通知来实现每个按钮在转动之后的位置（每次出现在最上方的按钮）
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tag" object:self userInfo:@{@"tag":[NSNumber numberWithInteger:butt.tag]}];
        }
    }
    
}

- (void)dealloc{
    [arrImages release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentCount" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tag" object:nil];
    
    
    [super dealloc];
}

@end
