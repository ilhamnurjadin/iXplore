//
//  NewEntryViewController.swift
//  iXplore
//
//  Created by Ilham Nurjadin on 7/11/16.
//  Copyright © 2016 IlhamNurjadin. All rights reserved.
//

import UIKit
import MapKit

class NewEntryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting title of navigation bar
        self.navigationItem.title = "New Journal Entry"
        
        // Create selector
        let selector = #selector(dismissCurrentViewController)
        
        // Create Cancel Bar Button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Done, target: self, action: selector)
        
        // Change button color of navigation controller
        self.navigationController!.navigationBar.tintColor = UIColor.orangeColor();
        
        // Add addButton to navigation bar of View Controller
        self.navigationItem.setLeftBarButtonItem(cancelButton, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        let newLatitude: Double? = Double(latitudeTextField.text!)!
        let newLongitude: Double? = Double(longitudeTextField.text!)!
        
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
            
            let todayDate = "\(day)/\(month)/\(year)"
            print(JournalEntryModelController.sharedInstance.returnJournalEntries())
            
            // Create Journal entry
            JournalEntryModelController.sharedInstance.addJournalEntry(titleTextField.text!, subtitle: notesTextField.text!, coordinate: coordinate, date: todayDate)
            
            dismissCurrentViewController()
            
        }
        else {
            
            print("you fucked up")
            // Create Alert
            
        }
        
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
