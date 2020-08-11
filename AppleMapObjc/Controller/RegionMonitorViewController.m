//
//  RegionMonitorViewController.m
//  AppleMapObjc
//
//  Created by Tong Yi on 8/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "RegionMonitorViewController.h"
#import "AlertManager.h"

@interface RegionMonitorViewController ()

@end

@implementation RegionMonitorViewController {
    __weak IBOutlet MKMapView *mapView;
    
    NSMutableArray<GeofenceAnnotation *> *geofences;
    CLLocationManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestUserAuthorization];
//    [self checkAuthorition];
    [self setup];
    [self stopMonitoringAllRegions];
    [self addMonitoringAnnotations];
}

//MARK: - setup for location manager
- (void)setup {
    manager = [[CLLocationManager alloc] init];
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.pausesLocationUpdatesAutomatically = YES;
    manager.distanceFilter = 10;
    manager.delegate = self;
    
    mapView.showsUserLocation = YES;
    geofences = [NSMutableArray new];
    
    UNUserNotificationCenter.currentNotificationCenter.delegate = self;
}

- (void)stopMonitoringAllRegions {
    for (CLRegion *region in manager.monitoredRegions) {
        [manager stopMonitoringForRegion:region];
    }
}

//- (void)checkAuthorition {
//    CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
//    switch (status) {
//        case kCLAuthorizationStatusNotDetermined:
//            [manager requestWhenInUseAuthorization];
//            break;
//        case kCLAuthorizationStatusRestricted:
//            break;
//        case kCLAuthorizationStatusDenied:
//            [manager requestWhenInUseAuthorization];
//            break;
//        case kCLAuthorizationStatusAuthorizedAlways:
//        case kCLAuthorizationStatusAuthorizedWhenInUse:
//            [manager startUpdatingLocation];
//            break;
//        default:
//            break;
//    }
//}

- (void)addMonitoringAnnotations {
    CLLocationCoordinate2D appleCoor = CLLocationCoordinate2DMake(37.3349285, -122.011033);
    CLLocationDegrees radius = 800.00;
    NSString *appleID= [[NSUUID alloc] init].UUIDString;
    NSString *appleNote = @"Left Apple Company!";
    EventType appleEventType = beExit;
    [self addGeotificationViewControllerDidAddCoordinate:appleCoor radius:radius identifier:appleID note:appleNote eventType:appleEventType];
    
    CLLocationCoordinate2D googleCoor = CLLocationCoordinate2DMake(37.422, -122.084058);
    NSString *googleID= [[NSUUID alloc] init].UUIDString;
    NSString *googleNote = @"Enter Google Company!";
    EventType googleEventType = beEntry;
    [self addGeotificationViewControllerDidAddCoordinate:googleCoor radius:radius identifier:googleID note:googleNote eventType:googleEventType];
}

// MARK: - User Notification
- (void)requestUserAuthorization {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Granted");
        } else {
            NSLog(@"Not Granted");
        }
    }];
}

//MARK: - map add & remove annotation Methods
- (void)addAnnotation: (GeofenceAnnotation *)geofenceAnnotation {
    [geofences addObject:geofenceAnnotation];
    [mapView addAnnotation:geofenceAnnotation];
    [self addRadiusOverlay:geofenceAnnotation];
    [self updateGeofencessCount];
}

- (void)removeAnnotation: (GeofenceAnnotation *)geofenceAnnotation {
    NSUInteger index = [geofences indexOfObject:geofenceAnnotation];
    [geofences removeObjectAtIndex:index];
    [mapView removeAnnotation:geofenceAnnotation];
    [self removeRadiusOverlay:geofenceAnnotation];
    [self updateGeofencessCount];
}

//MARK: - map overlay Methods
- (void)addRadiusOverlay: (GeofenceAnnotation *)geofenceAnnotation {
    [mapView addOverlay:[MKCircle circleWithCenterCoordinate:geofenceAnnotation.coordinate radius:geofenceAnnotation.radius]];
}

- (void)removeRadiusOverlay: (GeofenceAnnotation *)geofenceAnnotation {
    for (NSObject<MKOverlay> *overlay in mapView.overlays) {
        if ([overlay isKindOfClass:[MKCircle class]]) {
            MKCircle *circle = (MKCircle *)overlay;
            if (circle.coordinate.latitude == geofenceAnnotation.coordinate.latitude && circle.coordinate.longitude == geofenceAnnotation.coordinate.longitude) {
                [mapView removeOverlay:circle];
                break;
            }
        }
        
    }
}

- (void)updateGeofencessCount {
    self.title = [NSString stringWithFormat:@"Geotifications: %lu", (unsigned long)geofences.count];
}

- (void)addGeotificationViewControllerDidAddCoordinate: (CLLocationCoordinate2D)coor radius: (CLLocationDegrees)radius identifier: (NSString *)identifier note: (NSString *)note eventType: (EventType)eventType {
    double clampedRadius = MIN(radius, manager.maximumRegionMonitoringDistance);
    GeofenceAnnotation *geofence = [[GeofenceAnnotation alloc] initWithCoordinate:coor radius:clampedRadius identifier:identifier note:note eventType:eventType];
    [self addAnnotation:geofence];
    [self startMonitoring:geofence];
}

- (CLCircularRegion *)regionWith: (GeofenceAnnotation *)geofenceAnnotation {
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:geofenceAnnotation.coordinate radius:geofenceAnnotation.radius identifier:geofenceAnnotation.identifier];
    region.notifyOnEntry = (geofenceAnnotation.eventType == beEntry);
    region.notifyOnExit = !region.notifyOnEntry;
    
    return region;
}

- (void)startMonitoring: (GeofenceAnnotation *)geofenceAnnotation {
    if (![CLLocationManager isMonitoringAvailableForClass:CLCircularRegion.self]) {
        [AlertManager.manager alertWithTitle:@"Error" message:@"Geofencing is not supported on this device!" andController:self];
        return;
    }
    
    if (CLLocationManager.authorizationStatus != kCLAuthorizationStatusAuthorizedAlways) {
        NSString *message = @"Your geofence is saved but will only be activated once you grant"
        "region monitor has the permission to access the device location.";
        [AlertManager.manager alertWithTitle:@"Warning" message:message andController:self];
    }
    
    [manager startMonitoringForRegion:[self regionWith:geofenceAnnotation]];
}

- (void)stopMonitoring: (GeofenceAnnotation *)geofenceAnnotation {
    for (CLCircularRegion *region in manager.monitoredRegions) {
        if (region.identifier == geofenceAnnotation.identifier) {
            [manager stopMonitoringForRegion:region];
            break;
        }
    }
}

//MARK: - Notification
- (void)handleEventForRegion: (CLCircularRegion *)region {
    NSString * message = [self noteFromIdentifier:region.identifier];
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.body = message;
    content.sound = UNNotificationSound.defaultSound;
    content.badge = [NSNumber numberWithLong:UIApplication.sharedApplication.applicationIconBadgeNumber + 1];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"location_change" content:content trigger:trigger];
    [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error);
        }
    }];
    
    [[AlertManager manager] alertWithTitle:@"Note" message:message andController:self];
}

- (NSString *)noteFromIdentifier: (NSString *)identifier {
    GeofenceAnnotation *geofence = [GeofenceAnnotation new];
    for (geofence in geofences) {
        NSString *geoID = geofence.identifier;
        if ([geoID isEqual:identifier]) {
            return geofence.note;
            break;
        }
    }
    return nil;
}


//MARK: - IBAction Method
- (IBAction)zoomButtonTapped:(id)sender {
    [mapView centerToUserLocation];
}

//MARK: - Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        CLCircularRegion *circularRegion = (CLCircularRegion *)region;
        [self handleEventForRegion:circularRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        CLCircularRegion *circularRegion = (CLCircularRegion *)region;
       [self handleEventForRegion:circularRegion];
   }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Monitoring failed for region with identifier: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Monitoring failed for region with identifier: %@", error);
}

//MARK: - MKMapView Delegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSString *identifier = @"myGeotification";
    if ([annotation isKindOfClass:[GeofenceAnnotation class]]) {
        MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = YES;
            UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            removeButton.frame = CGRectMake(0, 0, 23, 23);
            [removeButton setImage:[UIImage systemImageNamed:@"multiply.circle"] forState:UIControlStateNormal];
            annotationView.leftCalloutAccessoryView = removeButton;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *render = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 1.0;
        render.strokeColor = UIColor.systemPinkColor;
        render.fillColor = [UIColor.systemPinkColor colorWithAlphaComponent:0.4];
        return render;
    }
    return [[MKOverlayRenderer alloc] initWithOverlay:overlay];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    GeofenceAnnotation *annotation = (GeofenceAnnotation *)view.annotation;
    [self stopMonitoring:annotation];
    [self removeAnnotation:annotation];
}

//MARK: - User Notification Center Delegate Method
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler((UNAuthorizationOptionAlert | UNAuthorizationOptionSound));
}

@end
