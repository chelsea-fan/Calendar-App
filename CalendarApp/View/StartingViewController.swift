//
//  StartingViewController.swift
//  CalendarApp
//
//  Created by Swarandeep on 01/06/24.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit

class StartingViewController: UIViewController, StoryboardInstantiable {
    
    class func create() -> StartingViewController {
        let vc = StartingViewController.instantiateViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleCalendarService.shared.setUpConfig()
        GoogleCalendarService.shared.handleSignInFlow(withPresenting: self) { results in
            let vc = CalendarScreenViewController.create(with: CalendarScreenViewModel(models: results))
            navController.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        GoogleCalendarService.shared.handleSignInFlow(withPresenting: self) { results in
            let vc = CalendarScreenViewController.create(with: CalendarScreenViewModel(models: results))
            navController.pushViewController(vc, animated: true)
        }
    }
}

