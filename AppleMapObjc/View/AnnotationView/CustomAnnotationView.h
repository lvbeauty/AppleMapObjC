//
//  CustomAnnotationView.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CustomCalloutView.h"


NS_ASSUME_NONNULL_BEGIN

@interface CustomAnnotationView : MKAnnotationView

@property (strong, nonatomic) CustomCalloutView *calloutView;

@end

NS_ASSUME_NONNULL_END
