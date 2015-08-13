//
//  RootViewController.m
//  地图demo
//
//  Created by JLItem on 15/8/12.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "RootViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface RootViewController () <CLLocationManagerDelegate>

// 创建定位管理者
@property (nonatomic, strong) CLLocationManager *mgr;

// 上一次的位置
@property (nonatomic, strong) CLLocation *previousLocation;

// 总距离和总时间
@property (nonatomic, assign) CGFloat sumDistance;
@property (nonatomic, assign) CGFloat sumTime;

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
    
    self.title = @"地图";
    self.view.backgroundColor = [UIColor cyanColor];
    
    
    // 设置代理
    self.mgr.delegate = self;
    
    // 判断是否是iOS8
    if ([[UIDevice currentDevice].systemVersion doubleValue]>= 8.0) {
        
        NSLog(@"iOS8.0");
        // 主动请求授权
        [self.mgr requestAlwaysAuthorization];
    }
    
    // 开始定位
    [self.mgr startUpdatingLocation];

}

#pragma mark --- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //    CLLocation; timestamp 当前获取到为止信息的时间
    /*
     获取走了多远（这一次的位置 减去上一次的位置）
     获取走这段路花了多少时间 （这一次的时间 减去上一次的时间）
     获取速度 （走了多远 ／ 花了多少时间）
     获取总共走的路程 （把每次获取到走了多远累加起来）
     获取平均速度 （用总路程 ／ 总时间）
     */
    // 获取当前的位置
    CLLocation *newLocation = [locations lastObject];
    if (self.previousLocation != nil) {
        
        // 计算两次的距离（单位是米）
        CLLocationDistance distance = [newLocation distanceFromLocation:self.previousLocation];
        
        // 计算两次之间的时间（单位是秒）
        NSTimeInterval dTime = [newLocation.timestamp timeIntervalSinceDate:self.previousLocation.timestamp];
        
        // 计算速度（米/秒）
        CGFloat speed = distance / dTime;
        
        // 累加距离
        self.sumDistance += distance;
        
        // 累加时间
        self.sumTime += dTime;
        
        // 计算平均速度
        CGFloat avgSpeed = self.sumDistance / self.sumTime;
        
        NSLog(@"距离%f  时间%f  速度%f ------- 总距离%f  总时间%f  平均速度%f",distance,dTime,speed,self.sumDistance,self.sumTime,avgSpeed);
        
    }
    
     self.previousLocation = newLocation;
    
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
