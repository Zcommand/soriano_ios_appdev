//
//  ViewController.swift
//  CampusCompanion
//
//  Created by John Ronen Soriano on 9/9/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Campus Companion"
        // Do any additional setup after loading the view.
    }

    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        subtitleLabel.text = "Let's get started!"
    }
    
}

