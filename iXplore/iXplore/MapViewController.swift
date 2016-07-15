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
        
        // doesn't work??
        //self.navigationController!.navigationBar.barTintColor = UIColor(red: 67, green: 67, blue: 67, alpha: 1)
        
        // Creating Add Button
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: selector)
        
        // Add addButton to navigation bar of View Controller
        self.navigationItem.setRightBarButtonItem(addButton, animated: true)
        
        // Table view has a cell
        self.tableView.registerNib(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
        cell.photoView.image = JournalEntryModelController.sharedInstance.journalEntryArray[indexPath.row].image
        
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            
            let tempID = JournalEntryModelController.sharedInstance.journalEntryArray[index.row].ID
            
            let manager = NSFileManager.defaultManager()
            let documents = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            
            do {
                let files = try manager.contentsOfDirectoryAtURL(documents, includingPropertiesForKeys: nil, options: [])
                for file in files {
                    if let entry = NSKeyedUnarchiver.unarchiveObjectWithFile(file.path!) as? JournalEntry {
                        if entry.ID == tempID {
                            do {
                                JournalEntryModelController.sharedInstance.journalEntryArray.removeAtIndex(index.row)
                                tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
                                try manager.removeItemAtPath(file.path!)
                            }
                            catch {
                                print("could not delete file")
                            }
                        }
                    }
                }
                
                tableView.reloadData()
                
            }
            catch {
            }
        }
        delete.backgroundColor = .redColor()
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            
        }
        edit.backgroundColor = .orangeColor()
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            // share to fb code
        }
        share.backgroundColor = .blueColor()
        
        return [delete, edit, share]
        
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
