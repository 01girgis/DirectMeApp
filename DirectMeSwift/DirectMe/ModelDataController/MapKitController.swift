//
//
//
//  Created by Romany GirGis, 2021.
//  Copyright © 2021 All rights reserved

import Foundation
import MapKit

// MARK: - LocalSearchCompleter Delegate Implementation
extension ViewController:MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let suggestResult = completer.results.first else {
            //in Case of Invalid Input Address
            completerLabel.text = "Invalid Address"
            completerLabel.textColor = .systemRed
            
            // Disable User Interaction
            completerLabel.isUserInteractionEnabled = false
            
            return
        }
        
        //Append first Suggestion to  Search Completer Label
        completerLabel.text = suggestResult.title
        completerLabel.isHidden = false
        completerLabel.textColor = .black
        
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

// MARK: - MapKit Delegate Implementation
extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .systemBlue
        return render
    }
}
