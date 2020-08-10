//
//  CLPlacemark+Category.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "CLPlacemark+Category.h"

@implementation CLPlacemark (Category)

- (NSMutableString *)completeAddress {
    NSMutableString *address = [NSMutableString new];
    if (!([self name] == nil)) {
        [address appendString:[self name]];
    }
    if (!([self locality] == nil)) {
        [address appendString:@", "];
        [address appendString:[self locality]];
    }
    if (!([self administrativeArea] == nil)) {
        [address appendString:@", "];
        [address appendString:[self administrativeArea]];
    }
    if (!([self postalCode] == nil)) {
        [address appendString:@", "];
        [address appendString:[self postalCode]];
    }
    if (!([self country] == nil)) {
        [address appendString:@", "];
        [address appendString:[self country]];
    }
    
    return address;
}

@end
