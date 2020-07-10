//
//  ShareLocationViewController.h
//  IMXMPPDemo
//
//  Created by Civet on 2020/7/10.
//  Copyright © 2020 PersonalONBYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <JZLocationConverter/JZLocationConverter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareLocationViewController : UIViewController

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) MKAnnotationView *annotationView;
@property (nonatomic,strong) CLGeocoder *geocoder;

@end

NS_ASSUME_NONNULL_END
