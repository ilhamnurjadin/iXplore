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
    var date: String?
    var coordinate: CLLocationCoordinate2D
    var note: String?
    
    init(title: String, date: String, coordinate: CLLocationCoordinate2D, note: String) {
        self.title = title
        self.date = date
        self.coordinate = coordinate
        self.note = note
    }
    
    required init(coder: NSCoder) {
        
        let latitude = (coder.decodeObjectForKey("latitude") as? CLLocationDegrees) ?? 0
        let longitude = (coder.decodeObjectForKey("longitude") as? CLLocationDegrees) ?? 0
        
        title = (coder.decodeObjectForKey("title") as? String) ?? ""
        date = (coder.decodeObjectForKey("date") as? String) ?? ""
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        note = (coder.decodeObjectForKey("note") as? String) ?? ""
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(title, forKey: "title")
        coder.encodeObject(date, forKey: "date")
        coder.encodeObject(coordinate.latitude, forKey: "latitude")
        coder.encodeObject(coordinate.longitude, forKey: "longitude")
        coder.encodeObject(note, forKey: "note")
    }
    
}