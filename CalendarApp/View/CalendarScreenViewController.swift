//
//  SecondViewController.swift
//  CalendarApp
//
//  Created by Swarandeep on 01/06/24.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit
import CalendarKit

class CalendarScreenViewController: DayViewController, StoryboardInstantiable {
    
    var viewModel: CalendarScreenViewModel!
    
    class func create(with viewModel: CalendarScreenViewModel) -> CalendarScreenViewController {
        let vc = CalendarScreenViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollToCurrentHour()
    }
    
    // scroll calendar page to current hour
    // example if the time is 4pm, then calendar will scroll to 4pm, giving good user experience
    func scrollToCurrentHour() {
        let hour = viewModel.getCurrentHour()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dayView.scrollTo(hour24: hour)
        }
    }
    
    // used to draw events on calendar
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
      var events = [Event]()

        for model in viewModel.models {
          let event = Event()
          event.dateInterval = DateInterval(start: model.startDate, end: model.endDate)
          event.text = model.title
          events.append(event)
      }
      return events
    }
    
    // when a particular event is clicked, we open event dedicated page
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        if let start = eventView.descriptor?.dateInterval.start, let end = eventView.descriptor?.dateInterval.end {
            let vc = EventDetailViewController.create()
            vc.titlePlaceholder = eventView.descriptor?.text
            let startDate = viewModel.getDateString(date: start)
            let endDate = viewModel.getDateString(date: end)
            vc.startDate = startDate
            vc.endDate = endDate
            navController.pushViewController(vc, animated: true)
        }
    }
    
    // when empty calendar is clicked, we open event creation page, passing the start time where the user has clicked
    // start time can be changed in event creation page
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        let vc = EventsCreationViewController.create(with: EventsCreationViewModel())
        navController.pushViewController(vc, animated: true)
    }
}
