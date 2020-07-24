//
//  ViewController.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/6/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h" //current project heaer file
#import "AlertManager.h"
#import "CLPlacemark+Category.h"
#import "CustomCalloutModel.h"
#import "CustomAnnotationView.h"
#import "ViewModel.h"
#import "LocationModel.h"
//#import <CoreLocation/CoreLocation.h> // framework // h file and m file, either of them has the framework h

@interface ViewController ()

@end

@implementation ViewController {
    __weak IBOutlet MKMapView *mapView;
    
    CLLocationManager *manager;
    CLLocation *mostAccurateLocation;
    CLLocation *previousAccurateLocation;
    UISearchController *searchController;
    dispatch_block_t waitingblock;
    NSMutableArray *item;
    NSString *pinID;
    ViewModel *viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDataSource];
    [self setupUI];
    [self setupLocationManager];
    [self setupMapKit];
}

- (void)setupLocationManager {
    manager = [[CLLocationManager alloc] init];
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.delegate = self;
}

- (void)setupMapKit {
    mapView.delegate = self;
    mapView.zoomEnabled = true;
    mapView.scrollEnabled = true;
    mapView.rotateEnabled = true;
    mapView.pitchEnabled = true;
    mapView.showsUserLocation = true;
    mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}

- (void)setupUI {
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [[searchController searchBar] sizeToFit];
    [searchController searchBar].delegate = self;
    [searchController searchBar].scopeButtonTitles = @[@"Standard", @"Satellite", @"Hybrid"];
    [searchController searchBar].showsScopeBar = true;
    searchController.hidesNavigationBarDuringPresentation = false;
    [self navigationItem].searchController = searchController;
}

- (void)setupDataSource {
    viewModel = ViewModel.new;
    [viewModel fetchLocationDataWithCompletionHandler:^{
        [self remoteDataShowingOnTheMap];
    }];
}

- (void)remoteDataShowingOnTheMap {
    for (LocationModel *data in viewModel.dataSource) {
        CLLocationDegrees latitude = (CLLocationDegrees)[data.latitude doubleValue];
        CLLocationDegrees longitude = (CLLocationDegrees)[data.longitude doubleValue];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        [self reverseGeocoderBetweenLocationAndAddressWithCoordinate:location.coordinate orAddress:nil completeHander:^(CLPlacemark *placemark) {
            NSString *address = [placemark completeAddress];
            
            if (address == nil) {
                address = @"No Address";
            }
            
            if (data.creater == nil) {
                data.creater = @"No Creater";
            }
            
            if (data.locate == nil) {
                data.locate = @"No Location";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->mapView addAnnotation:[[CustomAnnotation alloc] initWithViewModel:[[CustomCalloutModel alloc] init:data.creater :data.locate :[UIImage imageNamed:@"house"] at:location.coordinate :address] at:location.coordinate]];
            });
        }];
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        CLLocation *honolulu = [[CLLocation alloc] initWithLatitude:21.2924730 longitude:-157.8229380];
//        [self setCameraForPosition:honolulu andRegionRadius:10000];
//    });
}

-(void)centerToWithLocation: (CLLocation *)location andRegionRadius: (CLLocationDistance)regionRadius {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([location coordinate], regionRadius, regionRadius);
    mapView.region = region;
}

-(void)setCameraForPosition: (CLLocation *)location andRegionRadius: (CLLocationDistance)regionRadius {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([location coordinate], regionRadius, regionRadius);
    MKMapCameraBoundary *cameraBoundary = [[MKMapCameraBoundary alloc] initWithCoordinateRegion:region];
    mapView.cameraBoundary = cameraBoundary;
}

//MARK: - CLLocation Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [manager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            break;
        case kCLAuthorizationStatusDenied:
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [manager startUpdatingLocation];
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%@", locations);
    CLLocation *latestLoc = [locations lastObject];
    
    if (mostAccurateLocation == nil) {
        mostAccurateLocation = latestLoc;
    } else {
        if (([[latestLoc timestamp] timeIntervalSinceReferenceDate] - [[mostAccurateLocation timestamp] timeIntervalSinceReferenceDate]) > 5) {
            for (CLLocation *location in locations) {
                if ([mostAccurateLocation horizontalAccuracy] > [location horizontalAccuracy] || [mostAccurateLocation verticalAccuracy] > [location verticalAccuracy]) {
                    mostAccurateLocation = location;
                }
            }
            
            [manager stopMonitoringSignificantLocationChanges];
            [manager startMonitoringSignificantLocationChanges];
        }
    }
    
    if (!(mostAccurateLocation == previousAccurateLocation)) {
        previousAccurateLocation = mostAccurateLocation;
        
        [[AlertManager manager] alertWithTitle:@"LOCATION INFO" message:[mostAccurateLocation description] andController:self];
        [manager stopMonitoringSignificantLocationChanges];
        [manager startMonitoringSignificantLocationChanges];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [[AlertManager manager] alertWithTitle:@"Error" message:[error localizedDescription] andController:self];
}

//MARK: - Callout View Delegate Methods

- (void)coordinateButtonTapped:(CLLocationCoordinate2D)coordinate {
    CLLocationDegrees lat = coordinate.latitude;
    CLLocationDegrees lon = coordinate.longitude;
    
    NSString *latitude = [NSString stringWithFormat:@"%.7f", lat];
    NSString *longitude = [NSString stringWithFormat:@"%.7f", lon];
    NSMutableString *coordint = [NSMutableString new];
    [coordint appendString:@"Latitude: "];
    [coordint appendString:latitude];
    [coordint appendString:@",\n"];
    [coordint appendString:@"Longitude: "];
    [coordint appendString:longitude];
    
    [[AlertManager manager] alertWithTitle:@"Coordinate" message:coordint andController:self];
}

- (void)addressButtonTappedWithTitle:(NSString *)title :(NSString *)address {
    [[AlertManager manager] alertWithTitle:title message:address andController:self];
}

//MARK: - Geocoder Methods

- (void)reverseGeocoderBetweenLocationAndAddressWithCoordinate: (CLLocationCoordinate2D)coordinate orAddress: (NSString *)address completeHander: (void (^)(CLPlacemark *placemark))completehandler {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    __block CLPlacemark *placeMark = nil;
    
    if (address == nil) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error == nil) {
                placeMark = [placemarks firstObject];
                completehandler(placeMark);
            }
        }];
        
    } else {
        [geoCoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            placeMark = [placemarks firstObject];
            completehandler(placeMark);
        }];
    }
}

//MARK: - Map Kit View Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        pinID = @"_MapViewPinID";
        CustomAnnotation *myAnnotation = (CustomAnnotation *)annotation;
        CustomAnnotationView *annottionView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
        if (annottionView == nil) {
            annottionView = [[CustomAnnotationView alloc] initWithAnnotation:(id)myAnnotation reuseIdentifier:pinID];
            
            annottionView.annotation = (id)myAnnotation;
            annottionView.canShowCallout = false;
            annottionView.centerOffset = CGPointMake(0, -[annottionView bounds].size.height/2);
            annottionView.calloutView = (CustomCalloutView *)[[NSBundle.mainBundle loadNibNamed:@"CustomCalloutView" owner:nil options:nil] firstObject];
            annottionView.calloutView.delegate = self;
        }
        
        return annottionView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocation *location = [userLocation location];
    CLLocationCoordinate2D coordinate = location.coordinate;
    __block NSString *address;
    
    [mapView removeAnnotation:[[mapView annotations] firstObject]];
    
    [self reverseGeocoderBetweenLocationAndAddressWithCoordinate:coordinate orAddress:nil completeHander:^(CLPlacemark *placemark) {
        address = [placemark completeAddress];
        
        CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithViewModel:[[CustomCalloutModel alloc] init:@"107 Coffee Dessert" :@"Tina's cafe, Welcome!!" :[UIImage imageNamed:@"cafe"] at:coordinate :address] at:coordinate];
        
        [self centerToWithLocation:location andRegionRadius:10000];
        [mapView addAnnotation:(id)annotation];
        
    }];
    
}

//MARK: - Search Bar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!(waitingblock == nil)) {
        dispatch_block_cancel(waitingblock);
    }
  
    dispatch_block_t work = dispatch_block_create(0, ^{
        [searchBar resignFirstResponder];
        NSString *searchText = [[searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![searchText isEqual: @""]) {
            [self->mapView removeAnnotations:[self->mapView annotations]];
            [self performSearchByUsing:searchText];
            searchBar.placeholder = searchText;
        } else {
            searchBar.placeholder = @"Search";
        }
    });
    
    waitingblock = work;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), waitingblock);
}

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [mapView removeAnnotations:[mapView annotations]];
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString *searchText = [[searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![searchText isEqual: @""]) {
        [self performSearchByUsing:searchText];
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    switch ([searchBar selectedScopeButtonIndex]) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapView.mapType = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}

- (void)performSearchByUsing: (NSString *)searchText {
    [item removeAllObjects];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    request.region = [mapView region];
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && !([[response mapItems] count] == 0)) {
            
            NSLog(@"%lu", (unsigned long)[[response mapItems] count]);
            
            for (id object in [response mapItems]) {
                CLLocationCoordinate2D coordinate = [[object placemark] coordinate];
                [self reverseGeocoderBetweenLocationAndAddressWithCoordinate:coordinate orAddress:nil completeHander:^(CLPlacemark *placemark) {
                    NSString *address = [placemark completeAddress];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithViewModel:[[CustomCalloutModel alloc] init:[object name] :[object phoneNumber] :[UIImage imageNamed:@"house"] at:coordinate :address] at:coordinate];

                        [self->mapView addAnnotation:(id)annotation];
                    });
                }];
            }
        }
    }];
}

@end


//NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//[dict setValue: @"Tong" forKey: @"HAHA"];
//[self getDataFromSeverUsingURL: @"https://google.com" andParameter: dict];

//- (void) getDataFromSeverUsingURL: (NSString *)url andParameter: (NSDictionary *)para {
//
//}

//anyData = [NSArray arrayWithObjects:@"Li", [NSArray arrayWithObjects:@"Tong", @"Yu", nil], nil];
//NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: @"Value 1", @"key 1", @"Value 2", @"key 2", @"Value 3", @"key 3", nil]; /// difference syntax
//
//NSDictionary *dict2 = [NSDictionary dictionaryWithObjects: @[@"Tong", @"Yu", @"Tong", @"Yu", @"Tong"] forKeys:@[@"key 1", @"key 2", @"key 3", @"key 4", @"key 5"]]; //@[] is array
//
//NSDictionary *dictExample = @{
//    @"data": @{
//        @"age": @"6",
//        @"gender": @"male",
//        @"height": @"6"
//    }
//};
//NSArray *arr = @[@"Li", @"Tong", @"Yu", @"Zhao"];
//
//CustomAnnotation *annotaion = [[CustomAnnotation alloc] initWithTitle: @"titlr" andSubtitle: @"subtitle"];
