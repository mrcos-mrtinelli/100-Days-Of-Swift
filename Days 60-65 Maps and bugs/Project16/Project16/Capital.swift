//
//  Capital.swift
//  Project16
//
//  Created by Marcos Martinelli on 1/10/21.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var wikipediaPage: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, wikipediaPage: String) {
        self.title = title
        self.coordinate = coordinate
        self.wikipediaPage = wikipediaPage
    }
}
