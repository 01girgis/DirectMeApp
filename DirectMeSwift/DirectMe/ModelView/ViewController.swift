//
//
//
//  Created by Romany GirGis, 2021.
//  Copyright © 2021 All rights reserved

import UIKit
import CoreLocation
import MapKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet weak var myMAp: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var completerLabel: UILabel!
    @IBOutlet weak var centerLabel: UIButton!
    @IBOutlet weak var speedometerLabel: UILabel!
    
    let manageLocation  = CLLocationManager()          //Core Location Instance
    let searchCompleter =  MKLocalSearchCompleter()    //Search Completer Instance
    let networkMonitor = NWPathMonitor()               //NetWork Monitor  Instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load CLLocation Services & Network Connection
        NetworkCheck()
    }
    
}
