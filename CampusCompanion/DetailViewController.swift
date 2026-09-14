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
    var eventDate: Date = Date()
    var numberOfGuests: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Events"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let notificationStatus = notificationsEnabled ? "on" : "off"
        let formattedEventDate = dateFormatter.string(from: eventDate)

        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = """
        Welcome, \(studentName)! (\(selectedRole))
        Notifications: \(notificationStatus).
        Event: \(formattedEventDate)
        Guests: \(numberOfGuests)
        """
    }
}
