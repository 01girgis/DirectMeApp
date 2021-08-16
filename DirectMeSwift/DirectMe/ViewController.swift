//
//
//
//  Created by Romany GirGis, 2021.
//  Copyright © 2021 All rights reserved

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myMAp: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var completerLabel: UILabel!
    
    let manageLocation  = CLLocationManager()          //Core Location Instance
    let searchCompleter =  MKLocalSearchCompleter()    //Search Completer Instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load CLLocation Services
        loadServices()
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

// MARK: -CORELocation Delegate Implementation
extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Update Coordinates
        guard let location = locations.last else {
            print("error updat location.last")
            return
        }
        print("\(location.coordinate.latitude) //  \(location.coordinate.longitude)") //Debug Purpose
        
        
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


// MARK: - LocalSearchCompleter Delegate Implementation
extension ViewController:MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let suggestResult = completer.results.first else {
            //in Case of Invalid Input Address
            completerLabel.text = "Invalid Address"
            return
        }
        
        //Append first Suggestion to  Search Completer Label
        completerLabel.text = suggestResult.title
        completerLabel.isHidden = false
        
        // Enable User Interaction
        completerLabel.isUserInteractionEnabled = true
        
        //Gesture Recognizer for onClick Event to copy from Search Completer Label to Input Text
        let gestureEvent = UITapGestureRecognizer(target: self, action: #selector(copyText))
        completerLabel.addGestureRecognizer(gestureEvent)
        
    }
    
    //Copy Function
    @objc func copyText(){
        inputText.text = completerLabel.text
        completerLabel.isHidden = true
    }
    
    //error Handler
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        print(error)
    }
}
