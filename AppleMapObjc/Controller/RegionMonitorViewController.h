//
//  RegionMonitorViewController.h
//  AppleMapObjc
//
//  Created by Tong Yi on 8/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "GeofenceAnnotation.h"
#import "MKMapView+Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegionMonitorViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UNUserNotificationCenterDelegate>

@end

NS_ASSUME_NONNULL_END
