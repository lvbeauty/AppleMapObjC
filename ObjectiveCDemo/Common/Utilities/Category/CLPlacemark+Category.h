//
//  CLPlacemark+Category.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLPlacemark (Category)

- (NSMutableString *)completeAddress;

@end

NS_ASSUME_NONNULL_END
