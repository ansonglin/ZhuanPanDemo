//
//  MainViewController.m
//  CircleProject
//
//  Created by asl on 2017/3/20.
//  Copyright © 2017年 Invisionhealth Digital Inc. All rights reserved.
//

#import "MainViewController.h"
#import "CircleView.h"

@interface MainViewController ()
- (void)initDragImageView;
- (void)showImage;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UILabel *label;

@end

@implementation MainViewController

@synthesize label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (nil == _data) {
            _data = [NSMutableArray array];
            NSMutableArray *tempArr = [NSMutableArray array];
            
            NSDictionary *dic0 = @{@"state":@"0",
                                   @"title":@"我是一个好孩子啊0"
                                   };
            NSDictionary *dic1 = @{@"state":@"1",
                                   @"title":@"我们的国家1"
                                   };
            NSDictionary *dic2 = @{@"state":@"2",
                                   @"title":@"来日方长2"
                                   };
            NSDictionary *dic3 = @{@"state":@"3",
                                   @"title":@"人人网3"
                                   };
            NSDictionary *dic4 = @{@"state":@"4",
                                   @"title":@"来来来来4"
                                   };
            NSDictionary *dic5 = @{@"state":@"5",
                                   @"title":@"我们都是5"
                                   };
            [tempArr addObject:dic0];
            [tempArr addObject:dic1];
            [tempArr addObject:dic2];
            [tempArr addObject:dic3];
            [tempArr addObject:dic4];
            [tempArr addObject:dic5];
            
            _data = tempArr;
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    // 通知来实现当视图加载后知道转盘最上方的按钮，根据tag值来进行数据加载
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentValue:) name:@"currentCount" object:nil];
    
    [self initDragImageView];
    [self showImage];
    // 通知当每次转动结束之后记录转盘最上方的按钮，根据tag值来进行数据加载
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tag:) name:@"tag" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)currentValue:(NSNotification *)noti
{
    NSNumber *a = [noti.userInfo objectForKey:@"count"];
    NSInteger index = [a integerValue];
    count = index;
}


- (void)tag:(NSNotification *)notic
{
    NSNumber *a = [notic.userInfo objectForKey:@"tag"];
    NSInteger index = [a integerValue];
    NSDictionary *dic = [_data objectAtIndex:index];
    label.text = [dic objectForKey:@"title"];
}

- (void)initDragImageView{
    imageviewBi = [[DragBtn alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imageviewBi setBackgroundImage:[UIImage imageNamed:@"icon_contact"] forState:UIControlStateNormal];
    imageviewBi.tag = 0;
    [imageviewBi addTarget:self action:@selector(actiona:) forControlEvents:UIControlEventTouchUpInside];
    
    imageviewCustomerInfo = [[DragBtn alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imageviewCustomerInfo setBackgroundImage:[UIImage imageNamed:@"icon_favourite"] forState:UIControlStateNormal];
    imageviewCustomerInfo.tag = 1;
    [imageviewCustomerInfo addTarget:self action:@selector(actiona:) forControlEvents:UIControlEventTouchUpInside];
    
    imageviewDesire = [[DragBtn alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imageviewDesire setBackgroundImage:[UIImage imageNamed:@"icon_home"] forState:UIControlStateNormal];
    imageviewDesire.tag = 2;
    [imageviewDesire addTarget:self action:@selector(actiona:) forControlEvents:UIControlEventTouchUpInside];
    
    imageviewMyInfo = [[DragBtn alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imageviewMyInfo setBackgroundImage:[UIImage imageNamed:@"icon_mine"] forState:UIControlStateNormal];
    imageviewMyInfo.tag = 3;
    [imageviewMyInfo addTarget:self action:@selector(actiona:) forControlEvents:UIControlEventTouchUpInside];
    
    imageviewOrder = [[DragBtn alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imageviewOrder setBackgroundImage: [UIImage imageNamed:@"icon_shopping"]forState:UIControlStateNormal];
    imageviewOrder.tag = 4;
    [imageviewOrder addTarget:self action:@selector(actiona:) forControlEvents:UIControlEventTouchUpInside];
    
    
    imageviewPrice = [[DragBtn alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [imageviewPrice setBackgroundImage: [UIImage imageNamed:@"icon_shopping"]forState:UIControlStateNormal];
    imageviewPrice.tag = 5;
    [imageviewPrice addTarget:self action:@selector(actiona:) forControlEvents:UIControlEventTouchUpInside];
    
    arrImage = [[NSMutableArray alloc] initWithObjects:imageviewBi, imageviewCustomerInfo, imageviewDesire, imageviewMyInfo, imageviewOrder, imageviewPrice,nil];
    


}

//显示方式是确定圆心正下方的点，然后逆时针绘制点
- (void)showImage{
    CircleView *circleView = [[CircleView alloc] initWithFrame:CGRectMake(35, 100, 250, 250)];
    circleView.arrImages = arrImage;
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    image.center = CGPointMake(125, 125);
    image.image = [UIImage imageNamed:@"Yellow_Wheel"];
    [circleView addSubview:image];
    image.userInteractionEnabled = YES;
    
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    image1.center = CGPointMake(125, 125);
    image1.image = [UIImage imageNamed:@"Wheel_Cover"];
    [circleView addSubview:image1];
    image1.userInteractionEnabled = YES;
    
    
    UIButton * butt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    butt.layer.masksToBounds = YES;
    butt.layer.cornerRadius = 50;
    butt.backgroundColor = [UIColor grayColor];
    butt.center = CGPointMake(125, 125);
    UIImage *aa = [UIImage imageNamed:@"METAL_BOSS"];
    [butt setBackgroundImage:aa forState:UIControlStateNormal];
    
    [butt addTarget:self action:@selector(first) forControlEvents:UIControlEventTouchUpInside];
    [circleView addSubview:butt];
    
    [self.view addSubview:circleView];
    [circleView loadView];
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 400, 300, 100);
    label.backgroundColor = [UIColor cyanColor];
    NSDictionary *dic = [self.data objectAtIndex:count];
    
    label.text = [dic objectForKey:@"title"];
    
    [self.view addSubview:label];
    
}

- (void)actiona:(DragBtn *)sender
{
    NSLog(@"%ld", (long)sender.tag);
}

- (void)first
{
    NSLog(@"ok");
}

//- (NSMutableArray *)data
//{
//    if (nil == _data) {
//        _data = [NSMutableArray array];
//        NSMutableArray *tempArr = [NSMutableArray array];
//        
//        NSDictionary *dic0 = @{@"state":@"0",
//                               @"title":@"我是一个好孩子啊0"
//                               };
//        NSDictionary *dic1 = @{@"state":@"1",
//                               @"title":@"我们的国家1"
//                               };
//        NSDictionary *dic2 = @{@"state":@"2",
//                               @"title":@"来日方长2"
//                               };
//        NSDictionary *dic3 = @{@"state":@"3",
//                               @"title":@"人人网3"
//                               };
//        NSDictionary *dic4 = @{@"state":@"4",
//                               @"title":@"来来来来4"
//                               };
//        NSDictionary *dic5 = @{@"state":@"5",
//                               @"title":@"我们都是5"
//                               };
//        [tempArr addObject:dic0];
//        [tempArr addObject:dic1];
//        [tempArr addObject:dic2];
//        [tempArr addObject:dic3];
//        [tempArr addObject:dic4];
//        [tempArr addObject:dic5];
//        
//        _data = tempArr;
//    }
//    return _data;
//}










@end
