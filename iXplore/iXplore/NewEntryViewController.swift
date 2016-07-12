//
//  NewEntryViewController.swift
//  iXplore
//
//  Created by Ilham Nurjadin on 7/11/16.
//  Copyright © 2016 IlhamNurjadin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NewEntryViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let locManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    // Persistence
    let myFile = NSFileManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting title of navigation bar
        self.navigationItem.title = "Add Journal Entry"
        
        // Create selector
        let selector = #selector(dismissCurrentViewController)
        
        // Create Cancel Bar Button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: selector)
        
        // Change button color of navigation controller
        self.navigationController!.navigationBar.tintColor = UIColor.orangeColor();
        
        // Add addButton to navigation bar of View Controller
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: true)
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        
        locManager.desiredAccuracy = 90
        locManager.distanceFilter = 20
        locManager.startUpdatingLocation()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = CLLocationCoordinate2D(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // cast the object as an image
        if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            // what should this be?
            
            imageView.image = pickedImage
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func uploadImagePressed(sender: AnyObject) {
        self.presentViewController(imagePicker, animated: true) {}
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        let newLatitude: Double? = Double(latitudeTextField.text!)
        let newLongitude: Double? = Double(longitudeTextField.text!)
        
        if newLatitude != nil && newLongitude != nil {
            
            // Create coordinate
            let coordinate = CLLocationCoordinate2D(latitude: newLatitude!, longitude: newLongitude!)
            
            // Getting today's date
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let year =  components.year
            let month = components.month
            let day = components.day
            
            let todayDate = "\(month) \(day), \(year)"
            
            // Find documents folder
            let documents = myFile.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            
            // Create File
            let fileURL = documents.URLByAppendingPathComponent("JournalEntries.txt")
            
            // Adding entry to array
            JournalEntryModelController.sharedInstance.addJournalEntry(titleTextField.text!, date: todayDate, coordinate: coordinate, note: notesTextField.text!, image: imageView.image)
            
            // saving array
            NSKeyedArchiver.archiveRootObject(JournalEntryModelController.sharedInstance.journalEntryArray, toFile: fileURL.path!)
            
            dismissCurrentViewController()
            
        }
        else {
            
            print("you fucked up")
            // Create Alert
            
        }
        
    }
    
    @IBAction func updateToCurrentLocationPressed(sender: AnyObject) {
        
        latitudeTextField.text = String(currentLocation.latitude)
        longitudeTextField.text = String(currentLocation.longitude)
        
    }
    
    func dismissCurrentViewController() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
