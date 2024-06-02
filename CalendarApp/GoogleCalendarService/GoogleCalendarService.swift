//
//  GoogleCalendarService.swift
//  CalendarApp
//
//  Created by Swarandeep on 02/06/24.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import GoogleAPIClientForREST
import FirebaseCore

class GoogleCalendarService {
    
    private init() {}
    
    static let shared = GoogleCalendarService()
    let service = GTLRCalendarService()
    
    func setUpConfig() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    // this function first tries to restore previous sign in
    // if successful, then fetches calendar events
    // if not successful, then opens sign in page
    func handleSignInFlow(withPresenting: UIViewController, completion: @escaping ([EventModel])->()) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard let self = self else { return }
            if error != nil {
                openSignIn(withPresenting: withPresenting, completion: completion)
                return
            }
            self.openCalendar(user: user, completion: completion)
        }
    }
    
    // this functions opens sign in page where user can enter email and password to sign in
    // if successful, then fetches calendar events
    func openSignIn(withPresenting: UIViewController, completion: @escaping ([EventModel])->()) {
        GIDSignIn.sharedInstance.signIn(withPresenting: withPresenting, hint: nil, additionalScopes: ["https://www.googleapis.com/auth/calendar"]) { [weak self] result, error in
            guard error == nil else { return }
            self?.openCalendar(user: result?.user, completion: completion)
        }
    }
    
    func openCalendar(user: GIDGoogleUser?, completion: @escaping ([EventModel])->()) {
        guard let user = user, let idToken = user.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: user.accessToken.tokenString)
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            self?.service.authorizer = user.fetcherAuthorizer
            self?.fetchEvents(completion: completion)
        }
    }
    
    // fetches calendar events using calendar api
    func fetchEvents(completion: @escaping ([EventModel])->()) {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        service.executeQuery(query) { (ticket, events, error) in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            
            guard let events = events as? GTLRCalendar_Events, let items = events.items else { return }
            var result: [EventModel] = []
            for event in items {
                if let startDate = event.start?.dateTime?.date, let endDate = event.end?.dateTime?.date, let title = event.summary {
                    result.append(EventModel(startDate: startDate, endDate: endDate, title: title))
                }
            }
            completion(result)
        }
    }
    
    // creates calendar events using calendar api
    func createEvent(summary: String, startDate: Date, endDate: Date, completion: @escaping ()->()) {
        let event = GTLRCalendar_Event()
        event.summary = summary
        event.start = GTLRCalendar_EventDateTime()
        event.start?.dateTime = GTLRDateTime(date: startDate)
        event.end = GTLRCalendar_EventDateTime()
        event.end?.dateTime = GTLRDateTime(date: endDate)
        
        let query = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: "primary")
        service.executeQuery(query) { (ticket, event, error) in
            if let error = error {
                print("Error creating event: \(error)")
                return
            }
            
            completion()
        }
    }
    
}
