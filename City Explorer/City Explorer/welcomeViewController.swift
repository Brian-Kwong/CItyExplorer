//
//  welcomeViewController.swift
//  City Explorer
//
//  Created by brian on 11/12/23.
//

import UIKit

class welcomeViewController: UIViewController, UITextFieldDelegate {
    let userDef = UserDefaults.standard
    let jsonEncoder = JSONEncoder()
    var parentController: UIViewController!

    @IBOutlet var nameTextBox: UITextField!

    @IBOutlet var homeCityTextBox: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextBox.delegate = self
        homeCityTextBox.delegate = self
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var city = textField.text, !city.isEmpty else {
            popUpAlert("❔❔Input Error❔❔", "Please make sure you type in a entry", "OK") { _ in }
            return true
        }
        return true
    }

    func popUpAlert(_ title: String, _ message: String, _ buttonTitle: String, _ action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: action)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    @IBAction func saveSettings(_: UIButton) {
        if !nameTextBox.text!.isEmpty {
            userDef.setValue(nameTextBox.text, forKey: "name")
        }
        if !homeCityTextBox.text!.isEmpty {
            userDef.setValue(homeCityTextBox.text, forKey: "homeCity")
            parentController.viewDidLoad()
            dismiss(animated: true)
        }
    }
}
