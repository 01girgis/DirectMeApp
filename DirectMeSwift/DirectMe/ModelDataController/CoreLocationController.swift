//
//
//
//  Created by Romany GirGis, 2021.
//  Copyright © 2021 All rights reserved

import Foundation
import CoreLocation
import MapKit

// MARK: -CORELocation Delegate Implementation
extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Update Coordinates
        guard let location = locations.last else {
            print("error updat location.last")
            return
        }
        print("\(location.coordinate.latitude) //  \(location.coordinate.longitude)") //Debug Purpose
        
        //Implement Speedometer
        let objectSpeed = location.speed
        guard objectSpeed >= 0 else {
            return
        }
        speedometerLabel.text = "\(objectSpeed) KM"
        
        //Track Real-time Navigation Usr Location on Screen
        let centerLocation    = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let centerLocationView = MKCoordinateRegion.init(center: centerLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        myMAp.setRegion(centerLocationView, animated: true)
        
        
        //Get  GeoCoded Information
        CLGeocoder().reverseGeocodeLocation(location) { places, _ in
            guard let firstDestination = places?.first else { return }
            
            //addd current location to search field
            self.inputText.text =  firstDestination.name
        }
        
        //Erase current usr Location form text field for new search
        inputText.addTarget(self, action: #selector(textDidChange), for: .editingDidBegin)
        
        //Get Address from Input Text for Search Completer Suggestion Result
        inputText.addTarget(self, action: #selector(getAddressProccess), for: .editingChanged)
    }
    
    //Erase function
    @objc func textDidChange(){
        if inputText.text != ""  {
            inputText.text = ""
        }
    }
    
    //Getting Address to Search Completer Suggestion
    @objc func getAddressProccess(){
        guard let completerQuery = inputText.text else {
            if searchCompleter.isSearching {
                searchCompleter.cancel()
            }
            return
        }
        searchCompleter.queryFragment = completerQuery
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // on change authorization
        authorizationCheck()
    }
}
