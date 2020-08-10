//
//  CalloutViewPlus.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalloutViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CalloutViewPlus <NSObject>
- (void)configureCalloutWithViewModel: (NSObject<CalloutViewModel> *)viewModel;
@end

NS_ASSUME_NONNULL_END
