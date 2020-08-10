//
//  TableViewController.h
//  ObjectiveCDemo
//
//  Created by Tong Yi on 8/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HandleMapSearch.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UITableViewController <UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, weak) id <HandleMapSearch> delegate;

@end

NS_ASSUME_NONNULL_END
