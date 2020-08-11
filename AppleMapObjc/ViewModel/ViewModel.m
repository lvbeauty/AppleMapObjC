//
//  ViewModel.m
//  ObjectiveCDemo
//
//  Created by Tong Yi on 7/12/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

#import "ViewModel.h"
#import "ServiceManager.h"
#import "LocationModel.h"

@implementation ViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {}
    return self;
}

- (void)fetchLocationDataWithCompletionHandler:(void (^)(void))completionhandler {
    dispatch_queue_global_t defaultQ = dispatch_get_global_queue(QOS_CLASS_DEFAULT,0);
    dispatch_async(defaultQ, ^{
        NSURL *url = [NSURL URLWithString:@"https://data.honolulu.gov/resource/yef5-h88r.json"];
        NSData *fetchData = [[ServiceManager manager] fetchLocationJSONDataWithURL:url];
        
        NSError *error;
        
        NSArray *json = [NSJSONSerialization JSONObjectWithData:fetchData options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
        self.dataSource = NSMutableArray.new;
        
        for (NSDictionary *jsonDict in json) {
            NSString *creator = jsonDict[@"creator"];
            NSString *locat = jsonDict[@"location"];
            NSString *latitude = jsonDict[@"latitude"];
            NSString *longitude = jsonDict[@"longitude"];
            [self.dataSource addObject:[[LocationModel alloc] initWithCreater:creator andLocate:locat andLatitude:latitude andLongitude:longitude]];
        }
        
        completionhandler();
    });
}

@end
