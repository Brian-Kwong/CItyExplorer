//
//  settingsViewController.swift
//  City Explorer
//
//  Created by brian on 11/12/23.
//

import UIKit

class settingsViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var nameTextBox: UITextField!
    
    @IBOutlet var homeCityTextBox: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    
    
    @IBOutlet var resetButton: UIButton!
    
    
    let userDef = UserDefaults.standard
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextBox.delegate = self
        homeCityTextBox.delegate = self
        if let name = userDef.string(forKey: "name"){
            nameTextBox.text = name
        }
        if let homeCity = userDef.string(forKey: "homeCity"){
            homeCityTextBox.text = homeCity
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var city = textField.text, !city.isEmpty else {
            popUpAlert("Input Error", "Please make sure you type in a entry","OK"){_ in }
            return true
        }
        return true
    }
    
    func popUpAlert(_ title:String, _ message:String, _ buttonTitle:String,_ action:@escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title:buttonTitle , style: .default, handler: action)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    
    @IBAction func saveSettings(_ sender:UIButton) {
        if(!nameTextBox.text!.isEmpty)
        {
            userDef.setValue(nameTextBox.text, forKey: "name")
        }
        if(!nameTextBox.text!.isEmpty)
        {
            userDef.setValue(homeCityTextBox.text, forKey: "homeCity")
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func resetSettings(_ sender: UIButton) {
        userDef.setValue(nil, forKey: "name")
        userDef.setValue(nil, forKey: "homeCity")
        userDef.setValue(nil, forKey: "recentCities")
        userDef.setValue(nil, forKey: "savedCities")
        popUpAlert("Status", "Please restart the app to complete reset","OK", {_ in
            exit(0)
        })
    }
    
}
