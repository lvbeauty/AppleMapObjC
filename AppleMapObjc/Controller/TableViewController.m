//
//  TableViewController.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 8/10/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "TableViewController.h"
#import "CLPlacemark+Category.h"

@interface TableViewController ()

@end

@implementation TableViewController {
    NSArray<MKMapItem *> *matchingItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return matchingItems.count;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (_mapView != nil && searchController.searchBar.text != nil) {
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = searchController.searchBar.text;
        request.region = _mapView.region;
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
            if (response != nil) {
                self->matchingItems = [response mapItems];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [matchingItems objectAtIndex:indexPath.row].name;
    cell.detailTextLabel.text = [matchingItems objectAtIndex:indexPath.row].placemark.completeAddress;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKMapItem *selectItem = [matchingItems objectAtIndex:indexPath.row];
    [_delegate dropPinZoomInPlaceMark:selectItem];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
