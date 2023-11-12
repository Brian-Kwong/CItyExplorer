//
//  ViewController.swift
//  City Explorer
//
//  Created by brian on 11/10/23.
//

import UIKit
import CoreLocationUI
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet var locationButton: CLLocationButton!
    
    @IBOutlet var myTable: UITableView!
    
    let localManager = CLLocationManager()
    
    var cityData:[CityDataModel] = []
    var userLocation: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        localManager.delegate = self
        locationButton.addTarget(self, action:#selector(didTapButton), for: .touchUpInside)
        var location:Location
        if(userLocation.count < 1){
            location = Location(lat: 37.7749, long: -122.4194, name: "")
        }
        else{
            location = Location(lat: userLocation.first!.coordinate.latitude, long: userLocation.first!.coordinate.longitude, name: "")
        }
        CityAPI.shared.functionGetCityURLRequest(location){ [self]
            result in
            switch result{
            case .success(let cities):
                for city in cities{
                    PhotoIDAPI.shared.functionGetPhotoIDURLRequest(city.city){ [self]
                        result in
                        switch result{
                        case .success(let placeid):
                            PhotoAPI.shared.functionGetPhotoRefURLRequest(placeid){ [self]
                                result in
                                switch result{
                                case .success(let photosRef):
                                    cityData.append(CityDataModel(cityInfo: city, cityImages: photosRef))
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1){ [weak self] in
                                        self!.myTable.reloadData()
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "myCityCell", for: indexPath) as! CityTableView?
        let myCity = CityDataModel(cityInfo: cityData[indexPath.row].cityInfo, cityImages: cityData[indexPath.row].cityImages)
        cell?.configure(myCity)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myTable.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func didTapButton(){
        localManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.cityData = []
            self.viewDidLoad()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destinationController = segue.destination as? DetailedCityViiewController{
                let city = cityData[self.myTable.indexPathForSelectedRow!.row]
                destinationController.city = city
            }
            else{
                return
            }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation.append(locations.first!)
        self.localManager.stopUpdatingLocation()
    }
}

