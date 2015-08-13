//
//  ViewController.m
//  区域监测_demo
//
//  Created by JLItem on 15/8/13.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController () <CLLocationManagerDelegate>

/**
 *  定位管理者
 */
@property (nonatomic, strong) CLLocationManager *mgr;

@end

@implementation ViewController

- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 成为CoreLocation管理者的代理监听获取到的位置
    self.mgr.delegate = self;
    
    // 注意:如果是iOS8, 想进行区域检测, 必须自己主动请求获取用户隐私的权限
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        
        NSLog(@"是iOS8.0");
        [self.mgr requestAlwaysAuthorization];
    }
    
    // 开始检测用户所在的区域
    // 创建区域
    // CLRegion 有两个子类是专门用于指定区域的
    // 一个可以指定蓝牙的范围/ 一个是可以指定圆形的范围
    
    // 创建中心点
    // 第一个参数表示 纬度(0~180)
    // 第二个参数表示 经度(0~360)
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.058501, 116.304171);
    
    // 创建圆形区域，指定区域中心点的半径以及经纬度
    CLCircularRegion *circular = [[CLCircularRegion alloc] initWithCenter:center radius:1000 identifier:@"标示符（当有多个位置时，用来区分不同的位置）"];
    
    [self.mgr startMonitoringForRegion:circular];
    
}


#pragma mark --- CLLocationManagerDelegate

// 进入监听区域时调用
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"进入监听区域");
    
}

// 离开监听区域时调用
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"离开监听区域");
    
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
