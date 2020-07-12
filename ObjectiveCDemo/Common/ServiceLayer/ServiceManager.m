//
//  ServiceManager.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/12/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "ServiceManager.h"

@implementation ServiceManager

+ (instancetype)manager {
    static ServiceManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {}
    return self;
}

- (NSData *)fetchLocationJSONDataWithURL:(NSURL *)url {
    if (url == nil) {
        return nil;
    } else {
        NSData *data = [NSData dataWithContentsOfURL:url];
        return data;
    }
}

@end
