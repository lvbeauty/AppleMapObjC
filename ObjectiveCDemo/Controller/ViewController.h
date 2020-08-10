//
//  ViewController.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/6/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CustomCalloutViewModelDelegate.h"
#import "TableViewController.h"
#import "HandleMapSearch.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, CustomCalloutViewModelDelegate, HandleMapSearch>

@end


