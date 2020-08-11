//
//  MKMapView+Category.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 8/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "MKMapView+Category.h"

@implementation MKMapView (Category)

- (void)centerToUserLocation {
    CLLocationCoordinate2D coordinate = [self userLocation].location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self setRegion:region animated:YES];
}

@end
