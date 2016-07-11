//
//  JournalEntry.swift
//  iXplore
//
//  Created by Ilham Nurjadin on 7/11/16.
//  Copyright © 2016 IlhamNurjadin. All rights reserved.
//

import Foundation
import MapKit

class JournalEntry: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var date: String?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, date: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.date = date
    }
    
}