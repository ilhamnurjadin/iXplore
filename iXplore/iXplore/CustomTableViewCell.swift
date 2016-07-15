//
//  CustomTableViewCell.swift
//  iXplore
//
//  Created by Ilham Nurjadin on 7/12/16.
//  Copyright © 2016 IlhamNurjadin. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func infoButtonPressed(sender: AnyObject) {
        //presentMoreInfoViewController()
    }
    
//    func presentMoreInfoViewController() {
//        
//        // Create NewEntryViewController
//        let newEntryViewController = NewEntryViewController(nibName: "NewEntryViewController", bundle: nil)
//        
//        // Create navigation controller
//        let navController = UINavigationController(rootViewController: newEntryViewController)
//        
//        self.navigationController?.presentViewController(navController, animated: true) {}
//        
//    }
    
}
