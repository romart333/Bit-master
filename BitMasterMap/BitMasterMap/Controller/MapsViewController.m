//
//  MapViewController.m
//  BitMasterMap
//
//  Created by user167101 on 6/25/20.
//  Copyright © 2020 user167101. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapsViewController.h"
#import <BitMasterMap-Swift.h>
@interface MapsViewController ()
    @property (assign, nonatomic) float zoom;
@end

@implementation MapsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.zoom = 6;
       
    }
    return self;
}

- (void)loadView {
    if (self.repoModel == nil) { return; }
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:self.repoModel.latitude longitude:self.repoModel.longitude zoom:self.zoom];

    GMSMapView* mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView;

    GMSMarker* marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.repoModel.latitude, self.repoModel.longitude);
    marker.title = self.repoModel.name;
    marker.snippet = [NSString stringWithFormat:@"%d", [self.repoModel.stargazersCount intValue]];
    marker.map = mapView;
    mapView.delegate = self;
}
@end
