//
//  DetailViewController.swift
//  CampusCompanion
//
//  Created by John Ronen Soriano on 9/14/26.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    var studentName: String = ""
    var notificationsEnabled: Bool = false
    var selectedRole: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Events"
        
        let notificationStatus = notificationsEnabled ? "on" : "off"
        messageLabel.text = "Welcome, \(studentName)! (\(selectedRole)) Notifications: \(notificationStatus)."
    }
}
