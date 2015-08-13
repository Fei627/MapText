//
//  ViewController.m
//  反地理编码demo
//
//  Created by JLItem on 15/8/13.
//  Copyright (c) 2015年 JLItem. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
/**
 *  地理编码对象
 */
@property (nonatomic ,strong) CLGeocoder *geocoder;

#pragma mark - 反地理编码
- (IBAction)reverseGeocode;

@property (weak, nonatomic) IBOutlet UITextField *longtitudeField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UILabel *reverseDetailAddressLabel;

@end

@implementation ViewController

- (void)reverseGeocode
{
    // 1.获取用户输入的经纬度
    NSString *longtitude = self.longtitudeField.text;
    NSString *latitude = self.latitudeField.text;
    if (longtitude.length == 0 ||
        longtitude == nil ||
        latitude.length == 0 ||
        latitude == nil) {
        NSLog(@"请输入经纬度");
        return;
    }
    
    // 2.根据用户输入的经纬度创建CLLocation对象
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue]  longitude:[longtitude doubleValue]];
    
    // 3.根据CLLocation对象获取对应的地标信息
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *placemark in placemarks) {
            NSLog(@"%@ %@ %f %f", placemark.name, placemark.addressDictionary, placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            self.reverseDetailAddressLabel.text = placemark.locality;
        }
    }];
}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

@end
