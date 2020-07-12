//
//  CustomCalloutView.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "CustomCalloutView.h"
#import <CoreLocation/CoreLocation.h>
#import "CustomCalloutModel.h"

@implementation CustomCalloutView {
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
    __weak IBOutlet UIImageView *myImageView;
//    __weak IBOutlet UIButton *coordinateButton;
//    __weak IBOutlet UIButton *addressButton;
    
    CLLocationCoordinate2D coordinate;
    NSString *address;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)coordinateButtonTyped:(id)sender {
    [_delegate coordinateButtonTapped:coordinate];
}

- (IBAction)addressButtonTyped:(id)sender {
    [_delegate addressButtonTappedWithTitle:[titleLabel text] :address];
}

- (void)configureCalloutWithViewModel:(NSObject<CalloutViewModel> *)viewModel {
    
    CustomCalloutModel *vm = (CustomCalloutModel *)viewModel;
    
    titleLabel.text = [vm title];
    subtitleLabel.text = [vm subtitle];
    myImageView.image = [vm image];
    coordinate = [vm coordinate];
    address = [vm address];
}

@end
