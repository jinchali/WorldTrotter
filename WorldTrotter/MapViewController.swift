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
    
    var pinIndex = 0
    
    let placeOfBirth = MKPointAnnotation()
    let birthLocation = CLLocationCoordinate2DMake(40.4976, -74.4885)
    
    let currentLocation = MKPointAnnotation()
    let currentLocationCoord = CLLocationCoordinate2DMake(35.9732, -79.9950)
    
    let NYC = MKPointAnnotation()
    let NYCCoord = CLLocationCoordinate2DMake(40.7128, -74.0059)
    
    var hasDefaultLocation = false
    
    var calledFromLocation = false
    
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
        if(!hasDefaultLocation){
                 prevLocation = mapView.centerCoordinate
                hasDefaultLocation = true
        }
   
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setCenter((locationManager.location?.coordinate)!, animated: false)
        locateMe.backgroundColor = UIColor.blue
    }
    
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stop Loading")
        locateMe.backgroundColor = UIColor.white
        //FIGURE OUT A WAY TO ONLY SET CENTER WHEN CALLE FROM LOCATEUSER
        if(calledFromLocation)
        {
            mapView.setCenter(prevLocation, animated: false)
            calledFromLocation = false
        }
    }
    
    func locateUser()
    {
        print("Hello")
        if(!mapView.showsUserLocation)
        {
            mapView.removeAnnotations(self.mapView.annotations)
            mapView.showsUserLocation = true
            
        }
        else{
            calledFromLocation = true
            mapView.showsUserLocation = false

            
        }
        
    }
    
    func pins()
    {
        
        placeOfBirth.coordinate = birthLocation
        placeOfBirth.title = "Place of Birth"
        
        currentLocation.coordinate = currentLocationCoord
        currentLocation.title = "Current Location"
        
        NYC.coordinate = NYCCoord
        NYC.title = "New York City"
        
        if(!hasDefaultLocation)
        {
            prevLocation = mapView.centerCoordinate
            hasDefaultLocation = true
        }
        
        if(mapView.showsUserLocation)
        {
            mapView.showsUserLocation = false
        }
        
        if(pinIndex == 0){
             mapView.removeAnnotations(self.mapView.annotations)
            mapView.setCenter(birthLocation, animated: false)
        }
        else if(pinIndex == 1){
            mapView.removeAnnotations(self.mapView.annotations)
            mapView.addAnnotation(currentLocation)
            mapView.setCenter(currentLocationCoord, animated: false)
        }
        else if(pinIndex == 2){
             mapView.removeAnnotations(self.mapView.annotations)
            mapView.addAnnotation(NYC)
            mapView.setCenter(NYCCoord, animated: false)
        }
        else if(pinIndex == 3){
            mapView.setCenter(prevLocation, animated: false)
            hasDefaultLocation = false
            mapView.removeAnnotations(self.mapView.annotations)
        }
        
        pinIndex = (pinIndex+1)%4
        print(pinIndex)
    }

   

}
