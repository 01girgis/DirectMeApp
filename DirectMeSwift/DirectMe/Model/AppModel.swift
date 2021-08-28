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
                DispatchQueue.main.async { print("No Connection") }
                return
            }
            
            DispatchQueue.main.async { print("connected")}
            
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
}