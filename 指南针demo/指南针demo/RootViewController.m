//
//  RootViewController.m
//  指南针demo
//
//  Created by JLItem on 15/8/13.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "RootViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface RootViewController () <CLLocationManagerDelegate>

@property (nonatomic ,strong) CLLocationManager *mgr;

// 指南针图片
@property (nonatomic, strong) UIImageView *picImageView;

// 中轴线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation RootViewController

- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指南针";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        
        NSLog(@"是IOS8.0");
        [self.mgr requestAlwaysAuthorization]; // 主动请求授权
    }
    
    self.mgr.delegate = self;
    
    // 开始获取方向
    [self.mgr startUpdatingHeading];
    
    self.picImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhinanzhen"]];
    [self.view addSubview:self.picImageView];
    self.picImageView.center = CGPointMake(self.view.center.x, self.view.center.y);
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 1, 120, 2, 80)];
    self.lineView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lineView];
    
}

#pragma mark --- CLLocationManagerDelegate
// 当获取到用户方向时就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //NSLog(@" 方向 ");
    /*
     magneticHeading 设备与磁北的相对角度
     trueHeading 设置与真北的相对角度, 必须和定位一起使用, iOS需要设置的位置来计算真北
     真北始终指向地理北极点
     */
    NSLog(@"%f",newHeading.magneticHeading);
    
    // 1.将获取到的角度转为弧度 = (角度 * π) / 180;
    CGFloat angle = (newHeading.magneticHeading * M_PI) / 180;
    
    // 2.旋转图片
    /*
     顺时针 正
     逆时针 负数
     */
    self.picImageView.transform = CGAffineTransformIdentity;
    self.picImageView.transform = CGAffineTransformMakeRotation(- angle);
    
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

@end
