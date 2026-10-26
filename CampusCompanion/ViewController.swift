//
//  ViewController.swift
//  CampusCompanion
//
//  Created by John Ronen Soriano on 9/9/26.
//

import UIKit
import PhotosUI

private enum DefaultsKey {
    static let studentName = "studentName"
    static let notificationsEnabled = "notificationsEnabled"
    static let selectedRoleIndex = "selectedRoleIndex"
}

class ViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notifySwitch: UISwitch!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var guestStepper: UIStepper!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var removePhotoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Campus Companion"
        eventDatePicker.date = Date()
        nameTextField.text = UserDefaults.standard.string(forKey: DefaultsKey.studentName) ?? ""
        notifySwitch.isOn = UserDefaults.standard.bool(forKey: DefaultsKey.notificationsEnabled)
        roleSegmentedControl.selectedSegmentIndex =
            UserDefaults.standard.integer(forKey: DefaultsKey.selectedRoleIndex)
        profileImageView.layer.cornerRadius = 0
        loadProfileImageFromDisk()
        // Do any additional setup after loading the view.
    }

    @IBAction func changePhotoTapped(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                self?.profileImageView.contentMode = .scaleAspectFill
                self?.profileImageView.image = image
                self?.saveProfileImageToDisk(image)
            }
        }
    }

    private func saveProfileImageToDisk(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let documentsURL = FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsURL.appendingPathComponent("profilePhoto.jpg")
        do {
            try data.write(to: fileURL)
            removePhotoButton.isEnabled = true
        } catch {
            print("Could not save profile photo: \(error.localizedDescription)")
        }
    }

    private func loadProfileImageFromDisk() {
        guard let documentsURL = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsURL.appendingPathComponent("profilePhoto.jpg")
        if let image = UIImage(contentsOfFile: fileURL.path) {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = image
            removePhotoButton.isEnabled = true
        } else {
            profileImageView.contentMode = .scaleAspectFit
            removePhotoButton.isEnabled = false
        }
    }

    @IBAction func removePhotoTapped(_ sender: UIButton) {
        guard let documentsURL = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsURL.appendingPathComponent("profilePhoto.jpg")
        do {
            try FileManager.default.removeItem(at: fileURL)
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = UIImage(systemName: "person.crop.circle")
            removePhotoButton.isEnabled = false
        } catch {
            print("Could not remove profile photo: \(error.localizedDescription)")
        }
    }

    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        subtitleLabel.text = "Let's get started!"
    }
    @IBAction func exploreButtonTapped(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        let enteredName = nameTextField.text ?? ""
        
        UserDefaults.standard.set(enteredName, forKey: DefaultsKey.studentName)
        UserDefaults.standard.set(notifySwitch.isOn, forKey: DefaultsKey.notificationsEnabled)
        UserDefaults.standard.set(roleSegmentedControl.selectedSegmentIndex,
                                  forKey: DefaultsKey.selectedRoleIndex)
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
        
    }
    
    @IBAction func resetPreferencesTapped(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: DefaultsKey.studentName)
        UserDefaults.standard.removeObject(forKey: DefaultsKey.notificationsEnabled)
        UserDefaults.standard.removeObject(forKey: DefaultsKey.selectedRoleIndex)
        
        nameTextField.text = ""
        notifySwitch.isOn = false
        roleSegmentedControl.selectedSegmentIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetailSegue",
              let destination = segue.destination as? DetailViewController else {
            return
        }

        let enteredName = nameTextField.text ?? ""

        destination.studentName = enteredName.isEmpty ? "Student" : enteredName
        destination.notificationsEnabled = notifySwitch.isOn
        destination.selectedRole = roleSegmentedControl.selectedSegmentIndex == 0
            ? "Student" : "Faculty"
        destination.eventDate = eventDatePicker.date
        destination.numberOfGuests = max(1, Int(guestStepper.value))
    }
    
}
