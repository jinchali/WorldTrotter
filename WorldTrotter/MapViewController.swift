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
    let pinButton = UIButton()
    
    var trackingUser = false
    var prevLocation = CLLocationCoordinate2D()
    
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
        
        //Attempt to add location button
        locateMe.setTitleColor(UIColor.black, for: UIControlState.normal)
        locateMe.setTitle("Locate Me!", for: UIControlState.normal)
        locateMe.backgroundColor = UIColor.white
        locateMe.addTarget(self, action: "locateUser", for: UIControlEvents.touchUpInside)
        
        locateMe.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locateMe)
        
        let locateBottomConstraint = locateMe.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -60)

        locateBottomConstraint.isActive = true
        locateMe.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        
        //Attempt to add pin button
        pinButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        pinButton.setTitle("Pins", for: UIControlState.normal)
        pinButton.backgroundColor = UIColor.white
        pinButton.addTarget(self, action: "pins", for: UIControlEvents.touchUpInside)
        
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pinButton)
        
        let pinBottomConstraint = pinButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -60)
        
        pinBottomConstraint.isActive = true
        pinButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
 
        //locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        

        
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
        
        prevLocation = mapView.centerCoordinate
        mapView.setCenter((locationManager.location?.coordinate)!, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stop Loading")
        mapView.setCenter(prevLocation, animated: false)
    }
    
    func locateUser()
    {
        print("Hello")
        if(!mapView.showsUserLocation)
        {
            //prevLocation = mapView.centerCoordinate
            mapView.showsUserLocation = true
            locateMe.backgroundColor = UIColor.blue
            //trackingUser = true
            
        }
        else{
            mapView.showsUserLocation = false
            locateMe.backgroundColor = UIColor.white
            
        }
        
    }
    
    func pins()
    {
        var pinIndex = 0
        
        if(pinIndex == 0){
            
        }
        else if(pinIndex == 1){
            
        }
        else if(pinIndex == 2){
            
        }
        else if(pinIndex == 3){
            
        }
        
        pinIndex = (pinIndex+1)%4
    }


   

}
