//
//  EventViewController.swift
//  TimeShare MessagesExtension
//
//  Created by Iyin Raphael on 8/24/20.
//  Copyright © 2020 Iyin Raphael. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveSelectedDates(_ sender: UIButton) {
    }

}
