//
//  CustomAnnotation.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/8/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalloutViewModel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomAnnotation : NSObject <CalloutViewModel, MKAnnotation>

// bydefault --> readwrite
//@property (strong, readwrite, weak, nonatomic, atomic, retain, copy, assign, readonly)
//MARK: - Public Property
@property (copy, nonatomic) NSObject<CalloutViewModel> *vm;
//@property (nonatomic, readonly) CLLocationCoordinate2D myCoordinate;

//MARK: Public Methods
- (instancetype)initWithViewModel: (NSObject<CalloutViewModel> *)viewModel at:(CLLocationCoordinate2D)newCoordinate;

@end

NS_ASSUME_NONNULL_END
