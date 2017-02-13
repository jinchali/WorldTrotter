//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Jackson Inchalik on 2/5/17.
//  Copyright © 2017 Jackson Inchalik. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let locateMe = UIButton()
    var trackingUser = false
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        
        //Set it as *the* view of this view controller
        view = mapView
        
        locationManager.requestAlwaysAuthorization()
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        //Attempt to add button
        locateMe.setTitleColor(UIColor.black, for: UIControlState.normal)
        locateMe.setTitle("Locate Me!", for: UIControlState.normal)
        locateMe.backgroundColor = UIColor.white
        locateMe.addTarget(self, action: "locateUser", for: UIControlEvents.touchUpInside)
        
        locateMe.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locateMe)
        
        let locateBottomConstraint = locateMe.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -60)

        locateBottomConstraint.isActive = true
        locateMe.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
 
        //locationManager.startUpdatingLocation()
        
        //mapView.delegate = self
        
        mapView.showsUserLocation = true
        

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
        
    }
    
    func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("Start Loading")
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stop Loading")
    }
    
    func locateUser()
    {
        print("Hello")
        if(!trackingUser)
        {
            var prevLocation = mapView.centerCoordinate
            locateMe.backgroundColor = UIColor.blue
            trackingUser = true
        }
        else{
            locateMe.backgroundColor = UIColor.white
            trackingUser = false
            
        }
        
    }
 
}
