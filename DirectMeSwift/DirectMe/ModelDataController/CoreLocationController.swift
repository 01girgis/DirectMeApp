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
        var objectSpeed = location.speed
        if objectSpeed >= 0.0{
            speedometerLabel.text = "\(objectSpeed) KM"
            print("1")
        }
        else{
            objectSpeed = 0.0
            print("0")
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
     
    //Orientation Failure
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //get CLError Content
        if let errLocation = error as? CLError{
            switch errLocation {
            
            case CLError.locationUnknown:
                //in Case of Unknown Location
                self.completerLabel.text = "Location Orientation Lost"
                self.completerLabel.textColor = .systemRed
                self.completerLabel.isHidden = false
                print("no Location")
                
            case CLError.denied:
                //in Case of Deny Access to Location Services
                self.completerLabel.text = "Unable to Obtain Location Access"
                self.completerLabel.textColor = .systemRed
                self.completerLabel.isHidden = false
                print("denied")
            //Head to Main App Function Load
            case CLError.network:
                NetworkCheck()
                //other Error
            default:
                print(errLocation.localizedDescription)
            }
        }
    }
}
