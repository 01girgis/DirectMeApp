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
        checkServices()
    }
    
    //Main Check Services Function
    func checkServices(){
        //error Check
        if CLLocationManager.locationServicesEnabled() {
            manageLocation.delegate = self
            manageLocation.desiredAccuracy = kCLLocationAccuracyBest
        }
        else{
            //debug
            print("error 0")
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
