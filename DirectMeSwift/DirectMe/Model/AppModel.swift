//
//
//
//  Created by Romany GirGis, 2021.
//  Copyright © 2021 All rights reserved

import Foundation
import CoreLocation
import MapKit
import Network

extension ViewController{
    
    //Network Check Condition
    func NetworkCheck(){
        networkMonitor.pathUpdateHandler = { connection in
            
            //Condition Check
            guard connection.status == .satisfied
            else{
                DispatchQueue.main.async {
                    self.addressLabel.text = "No Internet"
                    self.addressLabel.textColor  = .systemRed
                }
                return
            }
            
            //Load App Services In Case of Connection to Internet
            DispatchQueue.main.async {
                self.addressLabel.text = "Type a Destination ?"
                self.addressLabel.textColor  = .black
                //
                self.loadServices()
            }
            
        }
        
        //Start Service
        let qu = DispatchQueue(label: "Network")
        networkMonitor.start(queue: qu)
    }
    
    
    //Main Services Function
    func loadServices(){
        //Check Services error
        if CLLocationManager.locationServicesEnabled() {
            //CLLocation delegation
            manageLocation.delegate = self
            manageLocation.desiredAccuracy = kCLLocationAccuracyBest
            
            //call Authorization
            authorizationCheck()
        }
        else{
            //debug
            print("error 0")
        }
    }
    
    //Authorization Procedures
    func authorizationCheck(){
        
        switch manageLocation.authorizationStatus {
        case .authorizedWhenInUse:
            myMAp.showsUserLocation = true             //Show Usr Location
            userLocationView()                        //Center Usr Location view on screen
            manageLocation.startUpdatingLocation()   //Start Update usr location
            searchCompleter.delegate = self         //Search Completer Delegation
            myMAp.delegate = self                  //mapKit Delegate
            break
        case .denied:
            break
        case .restricted:
            break
        case .notDetermined:
            manageLocation.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            break
        default:
            break
        }
        
    }
    
    /* MARK:- CONTROL BUTTONS ------------------------------------------------------------------------------------------ */
    
    //Relocate Usr Location button
    @IBAction func centerMeBtn(_ sender: Any) {
        userLocationView()
    }
    
    //center User Location
    func userLocationView(){
        if let usrLocation  = manageLocation.location?.coordinate{
            let usrView = MKCoordinateRegion.init(center: usrLocation, latitudinalMeters: 4000, longitudinalMeters: 4000)
            myMAp.setRegion(usrView, animated: true)
        }
    }
    
    //Navigation Button Setup
    @IBAction func navigationBtn (_ sender: Any){
        let initialPlace = (manageLocation.location?.coordinate)!
        
        //Geo Addressing
        let geoAddrees = CLGeocoder()
        geoAddrees.geocodeAddressString(completerLabel.text ?? ""){ (lastPlace,error) in
            guard let myfinalDestination = lastPlace,
                  let lastLocation = myfinalDestination.first?.location?.coordinate else  {
                //Debug Purpose
                print("error getting address")
                return
            }
            
            //Pass Addresses for Routing Proccess
            self.routingProccess(currentLocation: initialPlace, destinationPlace: lastLocation)
        }
    }
    
    //Routing Function
    func routingProccess(currentLocation:CLLocationCoordinate2D , destinationPlace:CLLocationCoordinate2D){
        //MapKit DirectionRquest
        let directionsRequest = MKDirections.Request()
        
        //Get Initial Addres & Address to Go
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation, addressDictionary: nil))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationPlace, addressDictionary: nil))
        directionsRequest.requestsAlternateRoutes = true
        directionsRequest.transportType = .automobile
        
        let directionsShow = MKDirections(request: directionsRequest)
        
        //Routing Addresses
        directionsShow.calculate(completionHandler: {(response,error)->Void in
            guard let getResponse = response else {
               
                //in Case of Invalid Routing To Address
                self.completerLabel.text = "No Route By Car"
                self.completerLabel.textColor = .systemRed
                self.completerLabel.isHidden = false
                // Disable User Interaction
                self.completerLabel.isUserInteractionEnabled = false
                
                //No Routing
                print ("error addressing")
                return
            }
            
            //Show Route between User Location & Destination Address
            if let route = getResponse.routes.first {
                self.myMAp.addOverlay(route.polyline)
                let rect = route.polyline.boundingMapRect
                self.myMAp.setRegion(MKCoordinateRegion(rect), animated: true)
            }
            
        })
    }
    
}
