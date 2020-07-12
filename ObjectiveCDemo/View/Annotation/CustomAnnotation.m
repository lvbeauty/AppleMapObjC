//
//  CustomAnnotation.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/8/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "CustomAnnotation.h"

//@interface CustomAnnotation () //class extension
//
//@property (strong, nonatomic) NSString *identifier;
//
//@end

@implementation CustomAnnotation //{
//   //private
//}
@synthesize coordinate;

- (instancetype)initWithViewModel:(NSObject<CalloutViewModel> *)viewModel at:(CLLocationCoordinate2D)newCoordinate {
    self = [super init];
    if (self) {
        _vm = viewModel;
        coordinate = newCoordinate;
    }
    
    return self;
}

@end
