//
//  MapViewController.swift
//  lab5FINAL
//
//  Created by David Sann on 5/27/19.
//  Copyright © 2019 David Sann. All rights reserved.
//
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //map.setCenter(startLocation, animated: true)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        map.setRegion(startRegion, animated: true)

        configureLocationManager()
    }
    
    func configureLocationManager() {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for nextLocation in locations {
            var newRegion = map.region
            newRegion.center = nextLocation.coordinate
            map.setRegion(newRegion, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation.subtitle! == "Class HQ") {
            let pinView = MKPinAnnotationView()
            pinView.pinTintColor = .red
            pinView.canShowCallout = true
            return pinView
        }
        
        if (annotation.subtitle! == "Food HQ") {
            let pinView = MKPinAnnotationView()
            pinView.pinTintColor = .green
            pinView.canShowCallout = true
            return pinView
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
