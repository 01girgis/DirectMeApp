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
    
}
