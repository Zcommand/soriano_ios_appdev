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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notifySwitch: UISwitch!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Campus Companion"
        // Do any additional setup after loading the view.
    }

    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        subtitleLabel.text = "Let's get started!"
    }
    @IBAction func exploreButtonTapped(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetailSegue",
              let destination = segue.destination as? DetailViewController else {
            return
        }

        let enteredName = nameTextField.text ?? ""

        destination.studentName = enteredName.isEmpty ? "Student" : enteredName
        destination.notificationsEnabled = notifySwitch.isOn
        destination.selectedRole = roleSegmentedControl.selectedSegmentIndex == 0
            ? "Student" : "Faculty"
    }
    
}

