//
//  UserScreenViewController.swift
//  City Explorer
//
//  Created by brian on 11/12/23.
//

import UIKit

class UserScreenViewController: UIViewController {
    @IBOutlet var savedCities: UIButton!

    @IBOutlet var userName: UILabel!

    @IBOutlet var userHomeCity: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let userDef = UserDefaults.standard
        if var name = userDef.string(forKey: "name") {
            userName.text = name
        }
        if var homeCity = userDef.string(forKey: "homeCity") {
            userHomeCity.text = homeCity
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        let userDef = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        var cities: Set<City> = []
        var userCitiesData: Data?
        if segue.identifier == "Settings" {
            if let destinationController = segue.destination as? settingsViewController {
                destinationController.parViewController = self
            }
            return
        } else if segue.identifier == "Recents" {
            userCitiesData = userDef.data(forKey: "recentCities")
            if userCitiesData == nil {
                DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                    popUpAlert("❔❔No Recents❔❔", "No recents retrieved", "Ok") { _ in }
                }
                return
            }
        } else if segue.identifier == "savedCities" {
            userCitiesData = userDef.data(forKey: "savedCities")
            if userCitiesData == nil {
                DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                    popUpAlert("❔❔No Saved Data❔❔", "No saved cities retrieved", "Ok") { _ in }
                }
                return
            }
        }
        if let citiesArraySet = try? jsonDecoder.decode(Set<City>.self, from: userCitiesData!) {
            cities = citiesArraySet
        }
        if cities.isEmpty, segue.identifier == "savedCities" {
            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                popUpAlert("❔❔No Saved Data❔❔", "No saved cities retrieved", "Ok") { _ in }
            }
        } else if cities.isEmpty, segue.identifier == "Recents" {
            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                popUpAlert("❔❔No Recents❔❔", "No recents retrieved", "Ok") { _ in }
            }
        } else {
            if let destinationController = segue.destination as? recentAndSavedCitiesViewController {
                destinationController.cities = cities
            } else {
                return
            }
        }
    }

    func popUpAlert(_ title: String, _ message: String, _ buttonTitle: String, _ action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: action)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
