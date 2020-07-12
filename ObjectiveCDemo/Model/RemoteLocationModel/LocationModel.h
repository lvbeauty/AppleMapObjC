//
//  LocationModel.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/12/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationModel : NSObject /* <NSCoding>*/

@property (strong, nonatomic) NSString *creater;
@property (strong, nonatomic) NSString *locate;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *address;

- (instancetype)initWithCreater: (NSString *)creater andLocate: (NSString *)locate andLatitude: (NSString *)latitude andLongitude: (NSString *)longitude;

@end

NS_ASSUME_NONNULL_END
