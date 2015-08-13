//
//  RootViewController.m
//  MapKit_基本使用demo
//
//  Created by JLItem on 15/8/13.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "RootViewController.h"
#import <MapKit/MapKit.h>

@interface RootViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *customMapView;
@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation RootViewController

- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
    }
    return _mgr;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.customMapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.customMapView];
    
    self.customMapView.mapType = MKMapTypeStandard; // 地图显示样式
    
    self.customMapView.rotateEnabled = NO; // 设置地图是否允许旋转（默认是允许）
    
    self.customMapView.delegate = self; // 成为mapVIew的代理
    
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        
        [self.mgr requestAlwaysAuthorization];
    }
    
    // 如果想利用MapKit获取用户的位置, 可以追踪
    /*
     typedef NS_ENUM(NSInteger, MKUserTrackingMode) {
     MKUserTrackingModeNone = 0, 不追踪/不准确的
     MKUserTrackingModeFollow, 追踪
     MKUserTrackingModeFollowWithHeading, 追踪并且获取用的方向
     }
     */
    self.customMapView.userTrackingMode = MKUserTrackingModeFollow;
}

#pragma MKMapViewDelegate
/**
 *  每次更新到用户的位置就会调用(调用不频繁, 只有位置改变才会调用)
 *
 *  @param mapView      促发事件的控件
 *  @param userLocation 大头针模型
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /*
     地图上蓝色的点就称之为大头针
     大头针可以拥有标题/子标题/位置信息
     大头针上显示什么内容由大头针模型确定(MKUserLocation)
     */
    // 设置大头针显示的内容
    //userLocation.title = @"龙哥";
    //userLocation.subtitle = @"威武";
    
    // 利用反地理编码获取位置之后设置标题
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = placemarks.firstObject;
        
        userLocation.title = placemark.name;
        userLocation.subtitle = placemark.locality;
    }];
    
    // 移动地图到当前用户所在位置
    // 获取用户当前所在位置的经纬度, 并且设置为地图的中心点 （iOS 8.0之后这项不需要再设置）
    // [self.customMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    // 设置地图显示的区域
    // 获取用户的位置
    
    /**
     *  下边的这些设置（对于iOS 8.0之后）没影响
     */
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    // 指定经纬度的跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    // 设置显示区域
    [self.customMapView setRegion:region animated:YES];
    
}

/**
 *  地图的区域即将改变时调用
 */
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //NSLog(@"地图的区域即将改变时调用");
}

/**
 *  地图的区域改变完成时调用
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"地图的区域改变完成时调用");
    
    NSLog(@"%f    %f",self.customMapView.region.span.longitudeDelta,self.customMapView.region.span.longitudeDelta);
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
