//
//  EventsCreationViewModel.swift
//  CalendarApp
//
//  Created by Swarandeep on 02/06/24.
//  Copyright (c) 2024 All rights reserved.
//

import Foundation

protocol EventsCreationViewModelProtocol {
    func createEvent(summary: String, startDate: Date, endDate: Date, completion: @escaping ()->())
}

class EventsCreationViewModel: EventsCreationViewModelProtocol {
    func createEvent(summary: String, startDate: Date, endDate: Date, completion: @escaping ()->()) {
        GoogleCalendarService.shared.createEvent(summary: summary, startDate: startDate, endDate: endDate, completion: completion)
    }
}
