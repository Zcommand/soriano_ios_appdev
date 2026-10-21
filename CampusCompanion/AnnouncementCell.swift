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
        titleLabel.text = announcement.title ?? ""
        let location = announcement.location.flatMap { $0.isEmpty ? nil : $0 } ?? "Not provided"
        let priority = announcement.priorityLevel.flatMap { $0.isEmpty ? nil : $0 } ?? "Not provided"
        dateLabel.text = "\(announcement.category ?? "") • \(announcement.date ?? "")\nLocation: \(location)\nPriority: \(priority)"
        categoryIconImageView.image = UIImage(systemName: "megaphone.fill")
        categoryIconImageView.tintColor = .systemBlue
        titleLabel.textColor = .label
    }
}
