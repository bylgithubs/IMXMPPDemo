//
//  ShareLocationViewController.m
//  IMXMPPDemo
//
//  Created by Civet on 2020/7/10.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import "ShareLocationViewController.h"

@interface ShareLocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, assign) double currentLatitude;   //当前纬度
@property (nonatomic, assign) double currentLongitude;  //当前经度

@end

@implementation ShareLocationViewController
@synthesize mapView;
@synthesize locationManager;
@synthesize geocoder;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI{
    [self setTitle:@"地图"];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    geocoder = [[CLGeocoder alloc] init];
    [self.view addSubview:mapView];
    mapView.delegate = self;
    //显示罗盘
    [mapView setShowsCompass:YES];
    //定位管理器
    locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    } else {
        mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        mapView.mapType = MKMapTypeStandard;
        locationManager.delegate = self;
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率，每隔多少米定位一次
        locationManager.distanceFilter = 1.0;   //1米定位一次
        //启动跟踪定位
        [locationManager startUpdatingLocation];//22.650861 114.045606
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate; //位置坐标
    //坐标系转换，转为火星坐标
    CLLocationCoordinate2D jzCoordinate = [JZLocationConverter wgs84ToGcj02:coordinate];
    self.currentLatitude = jzCoordinate.latitude;
    self.currentLongitude = jzCoordinate.longitude;
    NSLog(@"当前位置:%f %f",self.currentLatitude,self.currentLongitude);
    [self startReverseGeocoder:jzCoordinate];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    return nil;
}

//根据地址名称获取地理坐标
- (void)startGeocoder:(NSString *)address{
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        CLLocation *location = placemark.location; //位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic = placemark.addressDictionary; //详细地址信息字典,包含以下部分信息
//        NSString *name=placemark.name;//地名
//        NSString *thoroughfare=placemark.thoroughfare;//街道
//        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
//        NSString *locality=placemark.locality; // 城市
//        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
//        NSString *administrativeArea=placemark.administrativeArea; // 州
//        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
//        NSString *postalCode=placemark.postalCode; //邮编
//        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
//        NSString *country=placemark.country; //国家
//        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
//        NSString *ocean=placemark.ocean; // 海洋
//        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

//根据地理坐标获取地址信息
- (void)startReverseGeocoder:(CLLocationCoordinate2D)coordinate{
    NSLog(@"当前位置:%f %f",coordinate.latitude,coordinate.longitude);
    //反地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSDictionary *addressDic = placemark.addressDictionary;
        NSLog(@"当前地址详细信息:%@",addressDic);
    }];
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
