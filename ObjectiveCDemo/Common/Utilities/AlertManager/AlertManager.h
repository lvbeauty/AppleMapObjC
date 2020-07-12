//
//  AlertManager.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject

+ (instancetype)manager;

- (void)alertWithTitle: (NSString *)title andMessage:(NSString *)message andController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
