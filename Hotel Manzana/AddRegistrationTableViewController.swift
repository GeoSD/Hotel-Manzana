//
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Georgy Dyagilev on 20/10/2018.
//  Copyright © 2018 Georgy Dyagilev. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkinDateLabel: UILabel!
    @IBOutlet weak var checkinDatePicker: UIDatePicker!
    @IBOutlet weak var checkoutDateLabel: UILabel!
    @IBOutlet weak var checkoutDatePicker: UIDatePicker!

    @IBOutlet weak var adultsLabel: UILabel!
    @IBOutlet weak var childrenLabel: UILabel!
    @IBOutlet weak var selectedRoomLabel: UILabel!
    
    let checkinDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkoutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckinDatePickerShown = false {
        didSet {
            checkinDatePicker.isHidden = !isCheckinDatePickerShown
        }
    }
    var isCheckoutDatePickerShown = false {
        didSet {
            checkoutDatePicker.isHidden = !isCheckoutDatePickerShown
        }
    }
    
    var isWiFiNeeded = false
    var selectedRoomType: RoomType?
    var registrationForm: Registration?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkinDatePicker.minimumDate = midnightToday
        checkinDatePicker.date = midnightToday
        updateDateViews()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        
        showAlertWith(title: "Kindly reminder",
                      andMessage: "Please, remember that maximum 2 adults and 4 children per room is allowed.")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkinDatePickerCellIndexPath:
            if isCheckinDatePickerShown {
                return 216
            } else {
                return 0
            }
        case checkoutDatePickerCellIndexPath:
            if isCheckoutDatePickerShown {
                return 216
            } else {
                return 0
            }
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if firstNameTextField.isEditing && indexPath.section > 0 {
            firstNameTextField.resignFirstResponder()
        }
        if lastNameTextField.isEditing && indexPath.section > 0 {
            lastNameTextField.resignFirstResponder()
        }
        if emailTextField.isEditing && indexPath.section > 0 {
            emailTextField.resignFirstResponder()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (checkinDatePickerCellIndexPath.section, checkinDatePickerCellIndexPath.row - 1):
            if isCheckinDatePickerShown {
                isCheckinDatePickerShown = false
            } else if isCheckoutDatePickerShown {
                isCheckoutDatePickerShown = false
                isCheckinDatePickerShown = true
            } else {
                isCheckinDatePickerShown = true
            }
        case (checkoutDatePickerCellIndexPath.section, checkoutDatePickerCellIndexPath.row - 1):
            if isCheckoutDatePickerShown {
                isCheckoutDatePickerShown = false
            } else if isCheckinDatePickerShown {
                isCheckinDatePickerShown = false
                isCheckoutDatePickerShown = true
            } else {
                isCheckoutDatePickerShown = true
            }
        default:
            isCheckinDatePickerShown = false
            isCheckoutDatePickerShown = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty {
            showAlertWith(title: "Warning", andMessage: "Please, fill all fields in form.")
            return
        }
        
        if selectedRoomLabel.text == "Not Set" {
            showAlertWith(title: "Warning", andMessage: "Please, select Room Type.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY"
        
        let checkinDate = checkinDatePicker.date
        let checkoutDate = checkoutDatePicker.date
        let adultsCount = adultsLabel.text!
        let childrenCount = childrenLabel.text!
        
        registrationForm = Registration(firstName: firstName,
                                        lastName: lastName,
                                        emailAdress: email,
                                        checkInDate: checkinDate,
                                        checkOutDate: checkoutDate,
                                        numberOfAdults: Int(adultsCount)!,
                                        numberOfChildren: Int(childrenCount)!,
                                        roomType: selectedRoomType!,
                                        wifi: isWiFiNeeded)
        
        var stringWiFi = "No"
        if (registrationForm?.wifi)! {
            stringWiFi = "YES"
        }
        let message  = "First Name: \(registrationForm!.firstName)\nLast Name:\(registrationForm!.lastName)\nE-mail: \(registrationForm!.emailAdress)\nCheck-In: \(dateFormatter.string(from: registrationForm!.checkInDate))\nCheck-Out: \(dateFormatter.string(from: registrationForm!.checkOutDate))\nNumber of Adults: \(registrationForm!.numberOfAdults)\nNumber of Kids: \(registrationForm!.numberOfChildren)\nWi-fi: \(stringWiFi)\nType of room: \(registrationForm!.roomType.name)\n Price (per night): $\(registrationForm!.roomType.price)"
        showAlertWith(title: "Your booking info", andMessage: message)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    
    @IBAction func adultsStepperTapped(_ sender: UIStepper) {
        adultsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func childrenStepperTapped(_ sender: UIStepper) {
        childrenLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func wifiSwitch(_ sender: UISwitch) {
        isWiFiNeeded = sender.isOn
    }
    
    @IBAction func unwindToAddRegistrationForm(_ unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "UnwindToAddRegistration" else { return }
        
        let sourceViewController = unwindSegue.source as! SelectRoomTypeTableViewController
        selectedRoomType = sourceViewController.selectedRoomType
        selectedRoomLabel.text = selectedRoomType?.shortName
    }
    
    func updateDateViews() {
        checkoutDatePicker.minimumDate = checkinDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        checkinDateLabel.text = dateFormatter.string(from: checkinDatePicker.date)
        checkoutDateLabel.text = dateFormatter.string(from: checkoutDatePicker.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isCheckinDatePickerShown = false
        isCheckoutDatePickerShown = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func showAlertWith(title: String, andMessage: String) {
        let title = title
        let message = andMessage
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

}


