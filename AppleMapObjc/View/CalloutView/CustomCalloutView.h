//
//  CustomCalloutView.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCalloutViewModelDelegate.h"
#import "CalloutViewPlus.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomCalloutView : UIView <CalloutViewPlus>

@property (weak) IBOutlet UIButton *coordinateButton;
@property (weak) IBOutlet UIButton *addressButton;

@property (weak, nonatomic) NSObject<CustomCalloutViewModelDelegate>*delegate;

@end

NS_ASSUME_NONNULL_END
