//
//  ConfirmationViewController.swift
//  ClubConnect
//
//  Created by John Ronen Soriano on 9/19/26.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var memberName: String = "Club Member"
    var remindersEnabled: Bool = false
    var selectedRole: String = "Member"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Confirmation"

                let reminderStatus = remindersEnabled ? "enabled" : "disabled"

                messageLabel.text = """
                Welcome, \(memberName)!

                Role: \(selectedRole)
                Club reminders: \(reminderStatus)
                """
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
