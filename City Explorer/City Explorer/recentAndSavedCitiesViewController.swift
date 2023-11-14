//
//  recentAndSavedCitiesViewController.swift
//  City Explorer
//
//  Created by brian on 11/12/23.
//

import UIKit

class recentAndSavedCitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var myTable: UITableView!
    var cityData: [CityDataModel] = []
    var cities: Set<City> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
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
                                case let .failure(error):
                                    print(error)
                                }
                        }
                    case let .failure(error):
                        print(error)
                    }
            }
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

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTable.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let destinationController = segue.destination as? DetailedCityViiewController {
            let city = cityData[myTable.indexPathForSelectedRow!.row]
            destinationController.city = city
            destinationController.fromHome = false
        } else {
            return
        }
    }
}
