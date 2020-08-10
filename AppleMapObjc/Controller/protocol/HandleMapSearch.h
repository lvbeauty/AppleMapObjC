//
//  HandleMapSearch.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 8/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HandleMapSearch <NSObject>

- (void)dropPinZoomInPlaceMark: (MKMapItem *)mapItem;

@end

NS_ASSUME_NONNULL_END
