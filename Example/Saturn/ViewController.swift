//
//  ViewController.swift
//  Chronos
//
//  Created by Aleksey Getman on 10/22/2016.
//  Copyright (c) 2016 Aleksey Getman. All rights reserved.
//

import UIKit
import Saturn

class ViewController: UIViewController {
    
    @IBOutlet weak var deviceTimeLabel: UILabel!
    @IBOutlet weak var chronosTimeLabel: UILabel!
    var dateFormatter: DateFormatter!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH.mm.ss"
        fillLabels()
    }
    
    func fillLabels() {
        let deviceDate = Date()
        let deviceDateString = dateFormatter.string(from: deviceDate)
        deviceTimeLabel.text = deviceDateString
        
        Saturn.date { (date, result) in
            let chronosDateString = dateFormatter.string(from: date)
            chronosTimeLabel.text = chronosDateString
        }
    }

    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        fillLabels()
    }
    
}

