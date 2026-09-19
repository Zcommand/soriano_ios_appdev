//
//  ViewController.swift
//  ClubConnect
//
//  Created by John Ronen Soriano on 9/19/26.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // gives the "Club Title" its actual title na nilagay
        titleLabel.text = "Welcome to ClubConnect"
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        // Closes the keyboard before changing screens
            nameTextField.resignFirstResponder()
        
        // redirects to Confirmation View Controller
        performSegue(withIdentifier: "ShowConfirmationSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Ensures this is the correct segue and destination screen
            guard segue.identifier == "ShowConfirmationSegue",
                  let destination =
                    segue.destination as? ConfirmationViewController else {
                return
            }

            // Gets the entered name and removes unnecessary spaces
            let enteredName =
                nameTextField.text?.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ) ?? ""

            // Uses "Club Member" when the name field is empty
            destination.memberName =
                enteredName.isEmpty ? "Club Member" : enteredName

            // Passes the current reminder switch setting
            destination.remindersEnabled = reminderSwitch.isOn
        
            // Converts the selected segment into Member or Officer
            destination.selectedRole =
                roleSegmentedControl.selectedSegmentIndex == 0
                ? "Member"
                : "Officer"
        }
}
