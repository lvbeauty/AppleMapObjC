//
//  LocationModel.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/12/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

- (instancetype)initWithCreater:(NSString *)creater andLocate:(NSString *)locate andLatitude:(NSString *)latitude andLongitude:(NSString *)longitude {
    self = [super init];
    if (self) {
        self.creater = creater;
        self.locate = locate;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (instancetype)initWithLocation:(CLLocation *)location andAddress:(NSString *)address {
    self = [super init];
    if (self) {
        self.location = location;
        self.address = address;
    }
    
    return self;
}

//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    
//}
//
//- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
//    self = [super init];
//    if (self) {
//        self.creater = (NSString *)[coder decodeObjectForKey:@"creater"];
//        self.locate = (NSString *)[coder decodeObjectForKey:@"location"];
//        self.latitude = (NSString *)[coder decodeObjectForKey:@"latitude"];
//        self.longitude = (NSString *)[coder decodeObjectForKey:@"longitude"];
//    }
//    return self;
//}

@end
