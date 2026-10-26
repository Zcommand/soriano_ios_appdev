//
//  DetailViewController.swift
//  CampusCompanion
//
//  Created by John Ronen Soriano on 9/14/26.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var campusMapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!

    private enum CampusLocation {
        static let coordinate = CLLocationCoordinate2D(latitude: 14.6255, longitude: 121.0034)
    }

    private enum LibraryLocation {
        static let coordinate = CLLocationCoordinate2D(latitude: 14.6260, longitude: 121.0040)
    }

    private let locationManager = CLLocationManager()
    var announcement: CampusAnnouncement?
    var studentName: String = ""
    var notificationsEnabled: Bool = false
    var selectedRole: String = ""
    var eventDate: Date = Date()
    var numberOfGuests: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        configureMap()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if let announcement = announcement {
            title = announcement.category
            messageLabel.text = """
            \(announcement.title ?? "")
            \(announcement.date ?? "")
            """
            return
        }

        title = "Campus Events"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let notificationStatus = notificationsEnabled ? "on" : "off"
        let formattedEventDate = dateFormatter.string(from: eventDate)

        messageLabel.text = """
        Welcome, \(studentName)! (\(selectedRole))
        Notifications: \(notificationStatus).
        Event: \(formattedEventDate)
        Guests: \(numberOfGuests)
        """
    }

    private func configureMap() {
        let region = MKCoordinateRegion(center: CampusLocation.coordinate,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        campusMapView.setRegion(region, animated: false)

        let campusPin = MKPointAnnotation()
        campusPin.coordinate = CampusLocation.coordinate
        campusPin.title = "Campus"
        campusMapView.addAnnotation(campusPin)

        let libraryPin = MKPointAnnotation()
        libraryPin.coordinate = LibraryLocation.coordinate
        libraryPin.title = "Campus Library"
        campusMapView.addAnnotation(libraryPin)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            distanceLabel.text = "Location access denied."
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        let campusLocation = CLLocation(latitude: CampusLocation.coordinate.latitude,
                                        longitude: CampusLocation.coordinate.longitude)
        let distanceInMeters = currentLocation.distance(from: campusLocation)
        distanceLabel.text = String(format: "You are approximately %.0f meters from campus.",
                                    distanceInMeters)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        distanceLabel.text = "Current location unavailable."
        print("Location error: \(error.localizedDescription)")
    }
}
