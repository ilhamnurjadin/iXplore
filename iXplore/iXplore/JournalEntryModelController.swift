//
//  JournalEntryModelController.swift
//  iXplore
//
//  Created by Ilham Nurjadin on 7/11/16.
//  Copyright © 2016 IlhamNurjadin. All rights reserved.
//

import Foundation
import MapKit

class JournalEntryModelController {
    
    static let sharedInstance = JournalEntryModelController()
    
    var journalEntryArray: [JournalEntry] = {
        
        let manager = NSFileManager.defaultManager()
        let documents = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        do {
            let files = try manager.contentsOfDirectoryAtURL(documents, includingPropertiesForKeys: nil, options: [])
            var entries = [JournalEntry]()
            for file in files {
                if let entry = NSKeyedUnarchiver.unarchiveObjectWithFile(file.path!) as? JournalEntry {
                    entries.append(entry)
                }
            }
            return entries
        }
        catch {
            return []
        }
    }()
    
    private init() {
//        journalEntryArray = [JournalEntry(title: "Never@Home", subtitle: "Hostel Place that isn't too great", coordinate: CLLocationCoordinate2D(latitude: -33.907772, longitude: 18.40918), date: "10 July 2016"), JournalEntry(title: "Workshop 17", subtitle: "The Workplace ye", coordinate: CLLocationCoordinate2D(latitude: -33.9068, longitude: 18.4222), date: "11 July 2016"),]
    }
    
    func addJournalEntry(title: String, date: String, coordinate: CLLocationCoordinate2D, note: String, image: UIImage?) -> [JournalEntry] {
        
        let entry = JournalEntry(title: title, date: date, coordinate: coordinate, note: note, image: image)
        journalEntryArray.append(entry)        
        return journalEntryArray
        
    }
    
}
