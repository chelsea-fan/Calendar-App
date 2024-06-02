//
//  EventsCreationViewController.swift
//  CalendarApp
//
//  Created by Swarandeep on 02/06/24.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

class EventsCreationViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: EventsCreationViewModelProtocol!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var fromPicker: UIDatePicker!
    @IBOutlet weak var toPicker: UIDatePicker!
    
    class func create(with viewModel: EventsCreationViewModelProtocol) -> EventsCreationViewController {
        let vc = EventsCreationViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.placeholder = "Enter Event Title"
        fromPicker.datePickerMode = .time
        toPicker.datePickerMode = .time
        // we set a 30 min interval time for event, user can change it
        toPicker.setDate(Date().addingTimeInterval(30 * 60), animated: false)
    }
    
    @IBAction func addEventTapped(_ sender: Any) {
        // we check, whether the event title word count is greater than zero and event starttime is less than event endtime
        if let summary = titleTextField.text, summary.count > 0, toPicker.date > fromPicker.date {
            viewModel.createEvent(summary: summary, startDate: fromPicker.date, endDate: toPicker.date) { [weak self] in
                guard let self = self else { return }
                navController.popViewController(animated: true)
                if let vc = navController.topViewController as? CalendarScreenViewController {
                    vc.viewModel.models.append(EventModel(startDate: self.fromPicker.date, endDate: self.toPicker.date, title: summary))
                    vc.scrollToCurrentHour()
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navController.popViewController(animated: true)
    }
}
