//
//  CampusAnnouncement.swift
//  CampusCompanion
//
//  Created by John Ronen Soriano on 9/30/26.
//

import Foundation

struct CampusAnnouncement {
    let title: String
    let date: String
    let category: String
    let priority: String
    let postedBy: String
}

extension CampusAnnouncement {
    static let sampleAnnouncements: [CampusAnnouncement] = [
        CampusAnnouncement(title: "Enrollment Period Extended",
                           date: "August 3, 2026",
                           category: "Registrar", priority: "Normal",
                           postedBy: "Registrar"),
        CampusAnnouncement(title: "Classes Suspended Due to Flooding",
                           date: "September 30, 2026",
                           category: "Weather Update",
                           priority: "Urgent",
                           postedBy: "Office of Student Affairs"),
        CampusAnnouncement(title: "Transport Strike Advisory",
                           date: "October 1, 2026",
                           category: "Campus Advisory",
                           priority: "Urgent",
                           postedBy: "Campus Safety Office"),
        CampusAnnouncement(title: "Library Hours Extended",
                           date: "October 4, 2026",
                           category: "Library",
                           priority: "Normal",
                           postedBy: "University Library"),
        CampusAnnouncement(title: "Student Org Fair",
                           date: "October 7, 2026",
                           category: "Student Life",
                           priority: "Normal",
                           postedBy: "Student Affairs"),
        CampusAnnouncement(title: "Scholarship Deadline Reminder",
                           date: "October 11, 2026",
                           category: "Financial Aid",
                           priority: "Urgent",
                           postedBy: "Scholarship Office")
    ]
}
