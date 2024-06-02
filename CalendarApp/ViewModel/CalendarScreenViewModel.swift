//
//  CalendarScreenViewModel.swift
//  CalendarApp
//
//  Created by Swarandeep on 02/06/24.
//

import Foundation

protocol CalendarScreenViewModelProtocol {
    func getCurrentHour() -> Float
    func getDateString(date: Date) -> String
    var models: [EventModel] { get set }
}

class CalendarScreenViewModel: CalendarScreenViewModelProtocol {
    // used to store all calendar api received from api
    var models: [EventModel]
    
    init(models: [EventModel]) {
        self.models = models
    }
    
    func getCurrentHour() -> Float {
        let hour = Calendar.current.component(.hour, from: Date())
        return Float(hour)
    }
    
    func getDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a EEE d MMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}
