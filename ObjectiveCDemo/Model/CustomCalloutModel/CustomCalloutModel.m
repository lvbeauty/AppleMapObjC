//
//  CustomCalloutModel.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "CustomCalloutModel.h"

@implementation CustomCalloutModel

- (instancetype)init:(NSString *)title :(NSString *)subtitle :(UIImage *)image at:(CLLocationCoordinate2D)coordinate :(NSString *)address {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
        self.coordinate = coordinate;
        self.address = address;
    }
    
    return self;
}

@end
