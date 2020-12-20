//
//  EntryMapViewController.swift
//  nature-logger
//
//  Created by Sebastian Moldt on 20/12/2020.
//  Borrowed from exercise 11 about CoreLocation
//  Copyright © 2020 Syddansk Universitet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EntryMapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        self.addLocation()
    }
    
    private func addLocation() {
        if let location = location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "\(location.timestamp)"
            map.addAnnotation(annotation)
        }
    }
    
    private func center() {
        if let location = location {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            map.setRegion(region, animated: true)
        }
    }
}
extension EntryMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation {
            let alert = UIAlertController(title: "Position", message: "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
