//
//  ViewController.m
//  地理编码_demo
//
//  Created by lanou3g on 15/8/13.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


#define kViewWidth self.view.frame.size.width
#define kViewHeight self.view.frame.size.height

@interface ViewController ()

/**
 *  需要编码的地址输入框
 */
@property (nonatomic, strong) UITextField *addressTextField;
/**
*  经度容器
*/
@property (nonatomic, strong) UILabel *longitudeLable;
/**
*  纬度容器
*/
@property (nonatomic, strong) UILabel *latitudeLable;
/**
 *  详细地址容器
 */
@property (nonatomic, strong) UILabel *detailAddressLable;
/**
 *  地理编码对象
 */
@property (nonatomic, strong) CLGeocoder *geocoder;
/**
 *  地理编码按钮
 */
@property (nonatomic, strong) UIButton *geocoderButton;

@end

@implementation ViewController

/**
 *  地理编码对象 懒加载
 */
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 布局
    
    // 需要编码的地址输入框
    self.addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, kViewWidth - 60, 30)];
    self.addressTextField.backgroundColor = [UIColor orangeColor];
    self.addressTextField.placeholder = @"请输入地址";
    self.addressTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:self.addressTextField];
    
    // 编码按钮
    self.geocoderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.geocoderButton.frame = CGRectMake(30, 140, 80, 30);
    self.geocoderButton.backgroundColor = [UIColor orangeColor];
    [self.geocoderButton setTitle:@"地理编码" forState:UIControlStateNormal];
    [self.view addSubview:self.geocoderButton];
    [self.geocoderButton addTarget:self action:@selector(geocoderButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 经度
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 50, 30)];
    aLabel.text = @"经度";
    [self.view addSubview:aLabel];
    
    self.longitudeLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 200, 150, 30)];
    self.longitudeLable.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.longitudeLable];
    
    // 纬度
    UILabel *bLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 50, 30)];
    bLable.text = @"纬度";
    [self.view addSubview:bLable];
    
    self.latitudeLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 240, 150, 30)];
    self.latitudeLable.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.latitudeLable];
    
    // 详细地址
    UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 50, 30)];
    cLabel.text = @"地址";
    [self.view addSubview:cLabel];
    
    self.detailAddressLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 280, 250, 30)];
    self.detailAddressLable.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.detailAddressLable];
    
}

#pragma mark ----- 编码按钮的点击
- (void)geocoderButtonClick
{
    //NSLog(@"编码按钮的点击");
    
    // 1.获取用户的位置
    NSString *address = self.addressTextField.text;
    if (address == nil || address.length == 0) {
        NSLog(@"请输入地址");
        return;
    }
    
    // 2.创建地理编码对象
    
    // 3.利用地理编码对象编码
    // 根据传入的地址获取该地址对应的经纬度信息
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count == 0 || error != nil) {
            return ;
        }
        
        // placemarks地标数组, 地标数组中存放着地标, 每一个地标包含了该位置的经纬度以及城市/区域/国家代码/邮编等等...
        // 获取数组中的第一个地标
        
        CLPlacemark *placemark = placemarks.firstObject;
        
        self.longitudeLable.text = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
        self.latitudeLable.text = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
        
        NSArray *array = placemark.addressDictionary[@"FormattedAddressLines"];
        NSMutableString *mutableStr = [NSMutableString string];
        
        for (NSString *str in array) {
            
            [mutableStr appendString:str];
        }
        
        self.detailAddressLable.text = mutableStr;
    }];
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
