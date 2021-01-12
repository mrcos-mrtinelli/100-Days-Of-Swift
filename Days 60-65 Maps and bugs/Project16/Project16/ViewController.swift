//
//  ViewController.swift
//  Project16
//
//  Created by Marcos Martinelli on 1/10/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Style", style: .plain, target: self, action: #selector(changeMapStyle))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), wikipediaPage: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), wikipediaPage: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), wikipediaPage: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), wikipediaPage: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), wikipediaPage: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    @objc func changeMapStyle() {
        let ac = UIAlertController(title: "Please select a map style", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .standard
        }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: {[weak self] _ in
            self?.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        present(ac, animated: true, completion: nil)
        
//        if let wv = storyboard?.instantiateViewController(identifier: "WebView") {
//            navigationController?.pushViewController(wv, animated: true)
//        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // make sure that the annotation is of type Capital
        guard annotation is Capital else { return nil }
        
        // set the identifier we are using
        let identifier = "Capital"
        
        // dequeue and reuse our annotation view if it's a Capital type with the Capital identifier
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        annotationView?.pinTintColor = UIColor.systemPurple
        
        // if there isn't an annotation to reuse, create one
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = UIColor.systemPurple

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        if let wv = storyboard?.instantiateViewController(identifier: "WebView") as? WebViewViewController {
            wv.wikipediaURL = capital.wikipediaPage
            navigationController?.pushViewController(wv, animated: true)
        }
    }
}

