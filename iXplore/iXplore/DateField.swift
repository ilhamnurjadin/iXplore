//
//  DatePicker.swift
//  iXplore
//
//  Created by Ilham Nurjadin on 7/14/16.
//  Copyright © 2016 IlhamNurjadin. All rights reserved.
//

import UIKit

class DateField: UITextField {
    
    let datePickerKeyboard = UIDatePicker()
    var myDate: NSDate = NSDate()
    
//    var date: NSDate {
//        
//    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.inputView = datePickerKeyboard
        showCurrentDate()
        
        // Sets up a way for the textfield to recognize different events
        datePickerKeyboard.addTarget(self, action: #selector(updateText), forControlEvents: .ValueChanged)
        // self -- what we connect the target to (tells self to start listening for this event)
        // If the event occurs, we call the action on self
        // forControlEvent -- the state of the textfield
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.inputView = datePickerKeyboard
        showCurrentDate()
        
        datePickerKeyboard.addTarget(self, action: #selector(updateText), forControlEvents: .ValueChanged)
        
    }
    
    func updateText() {
        
        myDate = datePickerKeyboard.date;
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateInString = dateFormatter.stringFromDate(myDate)
        
        self.text = dateInString
    }
    
    func showCurrentDate() {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: myDate)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateInString = dateFormatter.stringFromDate(myDate)
        
        self.text = dateInString
    }

}
