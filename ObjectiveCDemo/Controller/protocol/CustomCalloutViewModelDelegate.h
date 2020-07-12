//
//  CustomCalloutViewModelDelegate.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CustomCalloutViewModelDelegate <NSObject>

@required
- (void)coordinateButtonTapped:(CLLocationCoordinate2D)coordinate;
- (void)addressButtonTappedWithTitle: (NSString *)title :(NSString *)address;

@end

