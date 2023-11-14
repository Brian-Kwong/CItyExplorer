//
//  ViewController.swift
//  City Explorer
//
//  Created by brian on 11/10/23.
//

import CoreLocation
import CoreLocationUI
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet var locationButton: CLLocationButton!

    @IBOutlet var SearchACity: UITextField!

    @IBOutlet var myTable: UITableView!

    @IBOutlet var refreshButton: UIButton!

    let localManager = CLLocationManager()

    var cityData: [CityDataModel] = []
    var userLocation: [CLLocation] = []
    var searchCity: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        cityData = []
        myTable.dataSource = self
        myTable.delegate = self
        localManager.delegate = self
        SearchACity.delegate = self
        locationButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        let userDef = UserDefaults.standard
        let name = userDef.string(forKey: "name")
        if name == nil {
            if let welcomeScreen = (storyboard?.instantiateViewController(withIdentifier: "welcomeScreen") as? welcomeViewController) {
                welcomeScreen.parentController = self
                welcomeScreen.isModalInPresentation = true
                present(welcomeScreen, animated: true)
            }
        }
        var location: Location
        var errorMessage = ""
        if !searchCity.isEmpty {
            location = Location(lat: 0, long: 0, name: searchCity)
        } else if userLocation.count >= 1 {
            location = Location(lat: userLocation.first!.coordinate.latitude, long: userLocation.first!.coordinate.longitude, name: "")
        } else if let name = userDef.string(forKey: "homeCity"),!name.isEmpty {
            location = Location(lat: 0, long: 0, name: name)
        } else {
            location = Location(lat: 37.7749, long: -122.4194, name: "")
        }
        CityAPI.shared.functionGetCityURLRequest(location) { [self]
            result in
                switch result {
                case let .success(cities):
                    if cities.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                            self!.popUpAlert("🌐🌐Search Error🌐🌐", "I'm sorry we've searched everywhere but the city you searched for doesnt seemed to exist (.﹒︣︿﹒︣.) If you're using a acronym try using the full name?", "OK") { _ in }
                        }
                    }
                    for city in cities {
                        var locationName = city.city + " ,"
                        locationName += city.region
                        locationName += " ,"
                        locationName += city.country
                        PhotoIDAPI.shared.functionGetPhotoIDURLRequest(locationName) { [self]
                            result in
                                switch result {
                                case let .success(placeid):
                                    PhotoAPI.shared.functionGetPhotoRefURLRequest(placeid) { [self]
                                        result in
                                            switch result {
                                            case let .success(photosRef):
                                                cityData.append(CityDataModel(cityInfo: city, cityImages: photosRef))
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                                                    self!.myTable.reloadData()
                                                }
                                            case .failure: break
                                                /* Blank */
                                            }
                                    }
                                case let .failure(error):
                                    printNetworkError(error.localizedDescription)
                                }
                        }
                    }
                case let .failure(error):
                    printNetworkError(error.localizedDescription)
                }
        }
    }

    func printNetworkError(_ errorMessage: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            [unowned self] in
            let alert = UIAlertController(title: "🔊🔊Network Erorr🔊🔊", message: errorMessage, preferredStyle: .alert)
            let reloadAction = UIAlertAction(title: "Try Again", style: .default) {
                [unowned self] _ in
                viewDidLoad()
            }
            let quitAction = UIAlertAction(title: "Close App", style: .default) { _ in
                exit(0)
            }
            alert.addAction(reloadAction)
            alert.addAction(quitAction)
            present(alert, animated: true)
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        cityData.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "myCityCell", for: indexPath) as! CityTableView?
        let myCity = CityDataModel(cityInfo: cityData[indexPath.row].cityInfo, cityImages: cityData[indexPath.row].cityImages)
        cell?.configure(myCity)
        return cell!
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var city = textField.text, !city.isEmpty else {
            popUpAlert("🌐🌐Search Error🌐🌐", "Please make sure you type in a valid search item", "OK") { _ in }
            return true
        }
        city = city.replacingOccurrences(of: " ", with: ",")
        cityAutoComplete.shared.functionGetCityFromSearchRequest(city) { [self]
            result in
                switch result {
                case let .success(cities):
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        if cities.isEmpty {
                            self.popUpAlert("🌐🌐Search Error🌐🌐", "I'm sorry we've searched everywhere but the city you searched for doesnt seemed to exist (.﹒︣︿﹒︣.) If you're using a acronym try using the full name?", "OK") { _ in }
                            return
                        } else {
                            self.searchCity = cities
                            self.userLocation = []
                            self.viewDidLoad()
                        }
                    }
                case let .failure(error):
                    printNetworkError(error.localizedDescription)
                }
        }
        textField.resignFirstResponder()
        return true
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTable.deselectRow(at: indexPath, animated: true)
    }

    func popUpAlert(_ title: String, _ message: String, _ buttonTitle: String, _ action: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: .default, handler: action)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

    @objc func didTapButton() {
        localManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.searchCity = ""
            self.SearchACity.text = "Search A City"
            self.viewDidLoad()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let destinationController = segue.destination as? DetailedCityViiewController {
            let city = cityData[myTable.indexPathForSelectedRow!.row]
            destinationController.city = city
            destinationController.fromHome = true
        } else {
            return
        }
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation.append(locations.first!)
        localManager.stopUpdatingLocation()
    }

    @IBAction func refreshPage(_: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.searchCity = ""
            self.SearchACity.text = "Search A City"
            self.viewDidLoad()
        }
    }
}
