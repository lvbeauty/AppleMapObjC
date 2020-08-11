//
//  GeofenceAnnotation.m
//  AppleMapObjc
//
//  Created by Tong Yi on 8/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "GeofenceAnnotation.h"

@implementation GeofenceAnnotation

@synthesize coordinate;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate radius:(CLLocationDegrees)radius identifier:(NSString *)identifier note:(NSString *)note eventType:(EventType)eventType {
    self = [super init];
    if (self) {
        coordinate = newCoordinate;
        _radius = radius;
        _identifier = identifier;
        _note = note;
        _eventType = eventType;
    }
    
    return self;
}

- (NSString *)title {
    if ([_note  isEqual: @"Left Apple Company!"]) {
        return @"Apple Company";
    } else { return @"Google Company";}
}

- (NSString *)subtitle {
    NSString *eventTypeValue = @"";
    
    switch (_eventType) {
        case beExit:
            eventTypeValue = @"Being Exit";
            break;
            
        default:
            eventTypeValue = @"Being Entry";
            break;
    }
    
    return [NSString stringWithFormat:@"Radius: %gm -> %@", _radius, eventTypeValue];
}

@end
