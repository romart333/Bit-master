//
//  MapViewController.swift
//  BitMasterMap
//
//  Created by user167101 on 6/13/20.
//  Copyright © 2020 user167101. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {

    /*private*/ var repoModel: RepoModel?
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override func loadView() {
        guard let repoModel = repoModel else { return }
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(repoModel.latitude), longitude: CLLocationDegrees(repoModel.longitude), zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.delegate = self
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(repoModel.latitude), longitude:CLLocationDegrees(repoModel.longitude))
        marker.title = repoModel.name
        if let stargazersCount = repoModel.stargazersCount {
            marker.snippet = String(stargazersCount.intValue)
        }
        marker.map = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setRepoModel(repoModel: RepoModel) {
        self.repoModel = repoModel
        print(repoModel.latitude)
        print(repoModel.longitude)
    }
}
