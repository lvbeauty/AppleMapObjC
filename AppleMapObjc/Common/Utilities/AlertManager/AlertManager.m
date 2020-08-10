//
//  AlertManager.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager

+ (instancetype)manager {
    static AlertManager *shared = nil;
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

- (void)alertWithTitle:(NSString *)title message:(NSString *)message andController:(UIViewController *)controller {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [controller presentViewController:alertController animated:true completion:nil];
}

@end
