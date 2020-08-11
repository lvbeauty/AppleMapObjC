//
//  GeofenceAnnotation.h
//  AppleMapObjc
//
//  Created by Tong Yi on 8/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    beEntry,
    beExit,
} EventType;

@interface GeofenceAnnotation : NSObject <MKAnnotation>

//@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDegrees radius;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *note;
@property (nonatomic) EventType eventType;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate radius: (CLLocationDegrees)radius identifier: (NSString *)identifier note: (NSString *)note eventType: (EventType) eventType;

@end

NS_ASSUME_NONNULL_END
