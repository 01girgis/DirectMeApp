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
            userLocationView()                        //Center Usr Location view on screen //->ControlButtons file
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
}
