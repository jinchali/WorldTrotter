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
    //Setting up views and other variables as members of class so they can be accessed from any function
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
    
    //Global booleans to later be used to let me know if we need a default location or not
    var hasDefaultLocation = false
    
    //Global boolean to let us know in our delegate functions that are called once showsUserLocaton = true
    //which function mutated the variable.
    var calledFromLocation = false
    
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        
        //Set it as *the* view of this view controller
        view = mapView
        
        locationManager.requestAlwaysAuthorization()
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        
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
        
        //Adding locateMe button to bottom left of screen and associate with "locateuser" function
        let locateMeString = NSLocalizedString("Locate Me!", comment: "Locate me Button")
        
        locateMe.setTitleColor(UIColor.black, for: UIControlState.normal)
        locateMe.setTitle(locateMeString, for: UIControlState.normal)
        locateMe.backgroundColor = UIColor.white
        locateMe.addTarget(self, action: "locateUser", for: UIControlEvents.touchUpInside)
        
        locateMe.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locateMe)
        
        let locateBottomConstraint = locateMe.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -60)

        locateBottomConstraint.isActive = true
        locateMe.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        
        //Adding pin button to bottom right of screen and associating it to "pins" function
        let pinsButtonString = NSLocalizedString("Pins", comment: "Pins Button")
        
        pinButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        pinButton.setTitle(pinsButtonString, for: UIControlState.normal)
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
        if(!hasDefaultLocation){
                 prevLocation = mapView.centerCoordinate
                hasDefaultLocation = true
        }
   
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Creating a view and a region so when we change the map position, we can also change zoom
        let userView = MKCoordinateSpanMake(10, 10)
        let userRegion = MKCoordinateRegionMake((locationManager.location?.coordinate)!, userView)

        mapView.setRegion(userRegion, animated: false)

        //Change the button's color so the user knows showsUserLocation has been turned ON
        locateMe.backgroundColor = UIColor.blue
    }
    
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        //Change the button's color so the user knows showsUserLocation has been turned OFF
        locateMe.backgroundColor = UIColor.white
        
        //This global variable let's us only run this code if it was called from locateUser
        if(calledFromLocation)
        {
            //Creates a view and region to change map's position along with view
            let regularView = MKCoordinateSpanMake(75, 75)
            let regularRegion = MKCoordinateRegionMake(prevLocation, regularView)
            mapView.setRegion(regularRegion, animated: false)
            calledFromLocation = false
        }
    }
    
    func locateUser()
    {
        if(!mapView.showsUserLocation)
        {
            //Remove all possible pins and chnages showsUserLocation to hit the delegate functions
            mapView.removeAnnotations(self.mapView.annotations)
            mapView.showsUserLocation = true
            
        }
        else{
            //Changes our global variable so we know here the delegate function from showsUserLocation = false is called from
            calledFromLocation = true
            mapView.showsUserLocation = false

            
        }
        
    }
    
    func pins()
    {
        //Setup of all pin's coordinates and titles so our user can see information about them
        
        placeOfBirth.coordinate = birthLocation
        placeOfBirth.title = "Place of Birth"
        
        currentLocation.coordinate = currentLocationCoord
        currentLocation.title = "Current Location"
        
        NYC.coordinate = NYCCoord
        NYC.title = "New York City"
        
        //Default zoom level to change to whenever we access a pin
        let regularView = MKCoordinateSpanMake(75, 75)
        
        //If there is no default locaton, save one and use or global variable to let us know we have it now
        if(!hasDefaultLocation)
        {
            prevLocation = mapView.centerCoordinate
            hasDefaultLocation = true
        }
        //Stops locating the user whenever the pin button is hit
        if(mapView.showsUserLocation)
        {
            mapView.showsUserLocation = false
        }
        
        //For pinIndex values 0-2, adds the pin to the mapView and changes the view to center on it.
        //For pinIndex value 3, removes all pins, and returns you to default location.

        
        if(pinIndex == 0){
             mapView.removeAnnotations(self.mapView.annotations)
            mapView.addAnnotation(placeOfBirth)

            let regularRegion = MKCoordinateRegionMake(birthLocation, regularView)
            mapView.setRegion(regularRegion, animated: false)
        }
        else if(pinIndex == 1){
            mapView.removeAnnotations(self.mapView.annotations)
            mapView.addAnnotation(currentLocation)

            let regularRegion = MKCoordinateRegionMake(currentLocationCoord, regularView)
            mapView.setRegion(regularRegion, animated: false)
        }
        else if(pinIndex == 2){
             mapView.removeAnnotations(self.mapView.annotations)
            mapView.addAnnotation(NYC)
            
            let regularRegion = MKCoordinateRegionMake(NYCCoord, regularView)
            mapView.setRegion(regularRegion, animated: false)
        }
        else if(pinIndex == 3){
            let regularRegion = MKCoordinateRegionMake(prevLocation, regularView)
            mapView.setRegion(regularRegion, animated: false)
            
            hasDefaultLocation = false
            mapView.removeAnnotations(self.mapView.annotations)
        }
        //Increments zoom
        pinIndex = (pinIndex+1)%4
    }

   

}
