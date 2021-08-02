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
    
    let manageLocation  = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load CLLocation Services
        loadServices()
    }
    
    //Main Services Function
    func loadServices(){
        //Check Services error
        if CLLocationManager.locationServicesEnabled() {
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
            myMAp.showsUserLocation = true
            userLocationView()
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
    
    //center User Location
    func userLocationView(){
        if let usrLocation  = manageLocation.location?.coordinate{
            let usrView = MKCoordinateRegion.init(center: usrLocation, latitudinalMeters: 4000, longitudinalMeters: 4000)
            myMAp.setRegion(usrView, animated: true)
        }
    }
    
}

//CORELocation Delegate Implementation
extension ViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
