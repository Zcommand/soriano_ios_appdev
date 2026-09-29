//
//  AnnouncementCell.swift
//  CampusCompanion
//
//  Created by John Ronen Soriano on 9/30/26.
//

import UIKit

class AnnouncementCell: UITableViewCell {
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configure(with announcement: CampusAnnouncement) {
        titleLabel.text = announcement.title

        if announcement.priority == "Urgent" {
            dateLabel.text = "\(announcement.category) • \(announcement.date) • URGENT"
            categoryIconImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            categoryIconImageView.tintColor = .systemRed
            titleLabel.textColor = .systemRed
        } else {
            dateLabel.text = "\(announcement.category) • \(announcement.date)"
            categoryIconImageView.image = UIImage(systemName: "megaphone.fill")
            categoryIconImageView.tintColor = .systemBlue
            titleLabel.textColor = .label
        }
    }
}
