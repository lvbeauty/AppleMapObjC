//
//  ViewModel.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/12/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewModel : NSObject

@property (strong, nonatomic) NSMutableArray *dataSource;

- (void)fetchLocationDataWithCompletionHandler: (void(^)(void)) completionhandler;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
