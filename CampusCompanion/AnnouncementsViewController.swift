//
//  AnnouncementsViewController.swift
//  CampusCompanion
//
//  Created by John Ronen Soriano on 9/30/26.
//

import UIKit
import CoreData

private enum RemoteEndpoint {
    // Temporary test feed while the module's shared endpoint returns 404.
    static let announcements = URL(string: "https://raw.githubusercontent.com/Zcommand/" +
                                   "soriano_ios_appdev/main/CampusCompanion/announcements-test.json")!
}

class AnnouncementsViewController: UITableViewController {
    private var announcements: [CampusAnnouncement] = []
    private var selectedAnnouncement: CampusAnnouncement?
    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Announcements"
        seedInitialAnnouncementsIfNeeded()
        loadAnnouncements()
    }

    private func seedInitialAnnouncementsIfNeeded() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        let existingCount = (try? context.count(for: request)) ?? 0
        guard existingCount == 0 else { return }

        let seedAnnouncements = [
            ("Enrollment Period Extended", "August 3, 2026", "Registrar"),
            ("Classes Suspended Due to Flooding", "September 30, 2026", "Weather Update"),
            ("Transport Strike Advisory", "October 1, 2026", "Campus Advisory"),
            ("Library Hours Extended", "October 4, 2026", "Library"),
            ("Student Org Fair", "October 7, 2026", "Student Life"),
            ("Scholarship Deadline Reminder", "October 11, 2026", "Financial Aid")
        ]

        for seed in seedAnnouncements {
            let announcement = CampusAnnouncement(context: context)
            announcement.title = seed.0
            announcement.date = seed.1
            announcement.category = seed.2
        }

        try? context.save()
    }

    private func loadAnnouncements() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        announcements = (try? context.fetch(request)) ?? []
        tableView.reloadData()
    }

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        fetchAnnouncementsFromServer()
    }

    private func fetchAnnouncementsFromServer() {
        let task = URLSession.shared.dataTask(with: RemoteEndpoint.announcements) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("Unexpected server response.")
                return
            }

            guard let data = data else { return }
            print("Reached network handler with \(data.count) bytes.")
            if let jsonText = String(data: data, encoding: .utf8) {
                print(jsonText)
            }

            do {
                let decodedAnnouncements = try JSONDecoder().decode([AnnouncementDTO].self, from: data)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.replaceAnnouncements(with: decodedAnnouncements)
                    self.showNetworkConfirmationAlert(byteCount: data.count)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }

    private func replaceAnnouncements(with dtos: [AnnouncementDTO]) {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        let existing = (try? context.fetch(request)) ?? []
        for item in existing {
            context.delete(item)
        }

        for dto in dtos {
            let announcement = CampusAnnouncement(context: context)
            announcement.title = dto.title
            announcement.date = dto.date
            announcement.category = dto.category
            announcement.location = dto.location
            announcement.priorityLevel = dto.priorityLevel
        }

        try? context.save()
        loadAnnouncements()
    }

    private func showNetworkConfirmationAlert(byteCount: Int) {
        let alert = UIAlertController(title: "Server Reached",
                                      message: "Received \(byteCount) bytes from the announcements endpoint.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func addAnnouncementTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Announcement",
                                      message: "Enter a title and category.",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Title"
        }
        alert.addTextField { textField in
            textField.placeholder = "Category"
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self = self,
                  let titleText = alert?.textFields?[0].text, !titleText.isEmpty,
                  let categoryText = alert?.textFields?[1].text, !categoryText.isEmpty else {
                return
            }

            let newAnnouncement = CampusAnnouncement(context: self.context)
            newAnnouncement.title = titleText
            newAnnouncement.date = DateFormatter.localizedString(from: Date(),
                                                                 dateStyle: .long,
                                                                 timeStyle: .none)
            newAnnouncement.category = categoryText
            newAnnouncement.location = ""
            newAnnouncement.priorityLevel = ""
            try? self.context.save()
            self.loadAnnouncements()
        }

        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "AnnouncementCell",
            for: indexPath
        ) as? AnnouncementCell else {
            return UITableViewCell()
        }

        cell.configure(with: announcements[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedAnnouncement = announcements[indexPath.row]
        performSegue(withIdentifier: "ShowAnnouncementDetailSegue", sender: self)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let announcement = announcements[indexPath.row]
            context.delete(announcement)
            try? context.save()
            announcements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowAnnouncementDetailSegue",
              let destination = segue.destination as? DetailViewController,
              let announcement = selectedAnnouncement else {
            return
        }

        destination.announcement = announcement
    }
}
