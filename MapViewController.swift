//
//  MapViewController.swift
//  lab5FINAL
//
//  Created by David Sann on 5/27/19.
//  Copyright © 2019 David Sann. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Foundation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

var selectedPin:MKPlacemark? = nil

var resultSearchController:UISearchController? = nil

let cscBuilding = CLLocationCoordinate2D(latitude: 35.300066, longitude: -120.662065)

let stationsURL = "https://gist.githubusercontent.com/ahmu83/38865147cf3727d221941a2ef8c22a77/raw/c647f74643c0b3f8407c28ddbb599e9f594365ca/US_States_and_Cities.json"

var cityList: [String : NSArray]? = nil

var ref: DatabaseReference!

var state: String?

var city: String?

let stateCodes = ["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
let fullStateNames = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]

class MapViewController: UIViewController {
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var viewGuides: UIButton!
    
    @IBOutlet weak var yourLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let startRegion = MKCoordinateRegion(center: cscBuilding, span: span)
        map.setRegion(startRegion, animated: true)
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

        locationSearchTable.mapView = map
        locationSearchTable.handleMapSearchDelegate = self
        
        ref = Database.database().reference()
        
        yourLabel.alpha = 0.0

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: stationsURL)!)
        let task: URLSessionDataTask = session.dataTask(with: request)
        { [unowned self] (receivedData, response, error) -> Void in
            if let data = receivedData {
                
                var jsonResponse: [String : NSArray]?
                do {
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : NSArray]
                    print("jsonResponse type: \(type(of: jsonResponse))")
                }
                catch {
                    print("Caught exception")
                }
                
                cityList = jsonResponse
                
                DispatchQueue.main.async {
                    self.reloadInputViews()
                }
            }
        }
        task.resume()
    }
    
    func shortStateName(_ state:String) -> String {
        let lowercaseNames = fullStateNames.map { $0.lowercased() }
        let dic = NSDictionary(objects: stateCodes, forKeys: lowercaseNames as [NSCopying])
        return dic.object(forKey:state.lowercased()) as? String ?? state}
    
    func longStateName(_ stateCode:String) -> String {
        let dic = NSDictionary(objects: fullStateNames, forKeys:stateCodes as [NSCopying])
        return dic.object(forKey:stateCode) as? String ?? stateCode
    }
    
    func pulseLabel(yourLabel: String) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: { self.yourLabel.alpha = 1.0 }, completion: {
            finished in
            
            if finished {
                //Once the label is completely invisible, set the text and fade it back in
                self.yourLabel.text = "Please Select A Different Area"
                
                // Fade in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                    self.yourLabel.alpha = 0.0
                }, completion: nil)
            }
        })
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "showGuides" {
            
            if map.annotations.count == 0 {
                pulseLabel(yourLabel: "yourLabel")
                return false
            }

            if (map.annotations[0].subtitle! != nil) {
                var loco = map.annotations[0].subtitle?!.split(separator: "/")
                if loco == nil {
                    pulseLabel(yourLabel: "yourLabel")
                    return false
                }
                state = longStateName(String(loco?[0] ?? ""))
                city = String(loco?[1] ?? "")

            } else {
                pulseLabel(yourLabel: "yourLabel")
                return false
            }
            
            
            for (key, value) in cityList! {
                if key == state {
                    for index in 0...value.count - 1 {
                        if value[index] as? String == city {
                            return true
                        }
                    }
                }
            }
            pulseLabel(yourLabel: "yourLabel")
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segue.destination is GuideTableViewController
        {
            let vc = segue.destination as? GuideTableViewController
            vc?.city = city
            vc?.state = state
        }
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        map.removeAnnotations(map.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = state + "/" + city
        }
        map.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        map.setRegion(region, animated: true)
    }
}
