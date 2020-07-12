//
//  CustomCalloutModel.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CalloutViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomCalloutModel : NSObject <CalloutViewModel>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *address;

- (instancetype)init: (NSString *)title :(NSString *)subtitle :(UIImage *)image at: (CLLocationCoordinate2D)coordinate :(NSString *)address;

@end

NS_ASSUME_NONNULL_END
