//
//  MapViewController.h
//  BitMasterMap
//
//  Created by user167101 on 6/25/20.
//  Copyright © 2020 user167101. All rights reserved.
//
#import <GoogleMaps/GoogleMaps.h>
#ifndef MapViewController_h
#define MapViewController_h

@class RepoModel;
@interface MapsViewController : UIViewController<GMSMapViewDelegate>
@property (strong, nonatomic) RepoModel* repoModel;
@end

#endif /* MapViewController_h */
