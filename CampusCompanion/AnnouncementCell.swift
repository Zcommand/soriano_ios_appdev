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
        let details = "\(announcement.category ?? "") • \(announcement.date ?? "")"
        let location = announcement.location ?? ""
        let priority = announcement.priorityLevel ?? ""
        dateLabel.text = location.isEmpty && priority.isEmpty
            ? details
            : "\(details)\n\(location) • \(priority)"
        categoryIconImageView.image = UIImage(systemName: "megaphone.fill")
        categoryIconImageView.tintColor = .systemBlue
        titleLabel.textColor = .label
    }
}
