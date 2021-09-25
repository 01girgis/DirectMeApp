//
//  ControlButtons.swift
//  DirectMe
//
//  Created by crus on 9/24/21.
//

import CoreLocation
import MapKit

extension ViewController{
   
    /* MARK:- CENTER BUTTON  */
    //Relocate Usr Location button
    @IBAction func centerMeBtn(_ sender: Any) {
        userLocationView()
        
        //Clear Navigation Status
        self.centerLabel.setTitle("Show-ME", for: .normal)
        self.myMAp.removeOverlays(self.myMAp.overlays)
        self.myMAp.removeAnnotations(self.myMAp.annotations)
    }
    
    //center User Location
    func userLocationView(){
        if let usrLocation  = manageLocation.location?.coordinate{
            let usrView = MKCoordinateRegion.init(center: usrLocation, latitudinalMeters: 4000, longitudinalMeters: 4000)
            myMAp.setRegion(usrView, animated: true)
        }
    }
    
    /* MARK:- NAVIGATION BUTTON  */
    //Navigation Button Setup
    @IBAction func navigationBtn (_ sender: Any){
        let initialPlace = (manageLocation.location?.coordinate)!
        
        //Geo Addressing
        let geoAddrees = CLGeocoder()
        geoAddrees.geocodeAddressString(completerLabel.text ?? ""){ (lastPlace,error) in
            guard let myfinalDestination = lastPlace,
                  let lastLocation = myfinalDestination.first?.location?.coordinate else  {
                //in Case of Invalid Routing To Address
                self.completerLabel.text = "No Valid Address Or it's your location"
                self.completerLabel.textColor = .systemRed
                self.completerLabel.isHidden = false
                //Debug Purpose
                print("error getting address")
                return
            }
            
            //Pass Addresses for Routing Proccess
            self.routingProccess(currentLocation: initialPlace, destinationPlace: lastLocation)
            
            //Pass Lastlocation For Pin Mark
            self.setAnnotationPinTo(lastLocation)
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
            
            //Set New Title For Center Button
            self.centerLabel.setTitle("Stop Navigation", for: .normal)
            
        })
    }
    
    //MKAnnotation Function
    func setAnnotationPinTo(_ Cordination:CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = Cordination
        annotation.title =  self.completerLabel.text
        self.myMAp.addAnnotation(annotation)
    }
    
    
}
