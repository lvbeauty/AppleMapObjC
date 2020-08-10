//
//  CustomAnnotationView.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"

@implementation CustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.image = [UIImage imageNamed:@"basic_annotation_image"];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if ([self isSelected] == selected) {
        return;
    }
    
    CustomAnnotation *annotation = (CustomAnnotation *)[self annotation];
    
    if (selected) {
        if ([self calloutView] == nil) {
            self.calloutView = (CustomCalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomCalloutView" owner:nil options:nil] firstObject];
        }
        
        CGFloat x = [self bounds].size.width/2 + [self calloutOffset].x;
        CGFloat y = -[[self calloutView] bounds].size.height/2 + [self calloutOffset].y;
        self.calloutView.center = CGPointMake(x, y);
        [[self calloutView] configureCalloutWithViewModel:[annotation vm]];
        [self addSubview:[self calloutView]];
    } else {
        [[self calloutView] removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
        if ([self calloutView] == nil) {
            return view;
        }
        
        CGPoint temPoint1 = [[[self calloutView] coordinateButton] convertPoint:point fromView:self];
        CGPoint temPoint2 = [[[self calloutView] addressButton] convertPoint:point fromView:self];
        
        if ([[[self calloutView] coordinateButton] pointInside:temPoint1 withEvent:nil]) {
            view = [[self calloutView] coordinateButton];
        }
        
        if ([[[self calloutView] addressButton] pointInside:temPoint2 withEvent:nil]) {
            view = [[self calloutView] addressButton];
        }
    }
    
    return view;
}



- (CGRect)getRectForEquilateralTriangleRelatedToHight: (CGFloat)height {
    CGFloat width = (height / pow(3, 1/2)) * 2;
    return CGRectMake(0, 0, width, height);
}

@end
