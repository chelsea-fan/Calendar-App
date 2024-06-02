//
//  ThirdViewController.swift
//  CalendarApp
//
//  Created by Swarandeep on 02/06/24.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    var titlePlaceholder: String?
    var startDate: String?
    var endDate: String?
    var startTime: Date?
    
    class func create() -> EventDetailViewController {
        let vc = EventDetailViewController.instantiateViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = titlePlaceholder
        if let startDate = startDate, let endDate = endDate {
            durationTextField.text = "From \(startDate) to \(endDate)"
        }
        titleTextField.isEnabled = false
        durationTextField.isEnabled = false
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navController.popViewController(animated: true)
    }
}
