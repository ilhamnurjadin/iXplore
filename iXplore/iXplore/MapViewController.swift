//
//  MapViewController.swift
//  iXplore
//
//  Created by Ilham Nurjadin on 7/11/16.
//  Copyright © 2016 IlhamNurjadin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    // Persistence
    let myFile = NSFileManager.defaultManager()
    
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        locManager.delegate = self
        
        let selector = #selector(presentNewViewControllerModally)
        
        // Creating Add Button
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: selector)
        
        // Add addButton to navigation bar of View Controller
        self.navigationItem.setRightBarButtonItem(addButton, animated: true)
        
        // Table view has a cell
        self.tableView.registerNib(UINib (nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Persistence
        // Find documents folder
        let documents = myFile.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        // Create File
        let fileURL = documents.URLByAppendingPathComponent("JournalEntries.txt")
        
        // Setting the stored array to the array in the model controller
        if let entries = NSKeyedUnarchiver.unarchiveObjectWithFile(fileURL.path!) as? [JournalEntry] {
            JournalEntryModelController.sharedInstance.journalEntryArray = entries
        }
        
        // Add annotations
        mapView.addAnnotations(JournalEntryModelController.sharedInstance.journalEntryArray)
        tableView.reloadData()
        
        locManager.requestWhenInUseAuthorization()
        locManager.desiredAccuracy = 90
        locManager.distanceFilter = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Title of Section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Journal Entries"
    }
    
    // Number of Rows in Section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JournalEntryModelController.sharedInstance.journalEntryArray.count
    }
    
    // What is displayed at each section
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as! CustomTableViewCell
        
        cell.titleLabel.text = JournalEntryModelController.sharedInstance.journalEntryArray[indexPath.row].title
        cell.dateLabel.text = JournalEntryModelController.sharedInstance.journalEntryArray[indexPath.row].date
        cell.imageView?.image = JournalEntryModelController.sharedInstance.journalEntryArray[indexPath.row].image
        
        return cell
    }
    
    // When a row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Sets the map's view when the app opens up (i.e. where the map points to)
        let location = JournalEntryModelController.sharedInstance.journalEntryArray[indexPath.row].coordinate  // location
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)  // how zoomed in your view is
        let region = MKCoordinateRegion(center: location, span: span)  // region where view is set to
        
        mapView.setRegion(region, animated: true)
        
    }
    
    // Set up the pin for the annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView?.isKindOfClass(MKUserLocation) == nil {
            return nil
        }
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            // Adding Callouts
            annotationView!.canShowCallout = true
            
        }
        
        // Setting annotation
        annotationView!.annotation = annotation
        
        return annotationView
        
    }
    
    func presentNewViewControllerModally() {
        
        // Create NewEntryViewController
        let newEntryViewController = NewEntryViewController(nibName: "NewEntryViewController", bundle: nil)
        
        // Create navigation controller
        let navController = UINavigationController(rootViewController: newEntryViewController)
        
        self.navigationController?.presentViewController(navController, animated: true) {}
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
