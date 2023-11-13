//
//  recentCitiesViewController.swift
//  City Explorer
//
//  Created by brian on 11/12/23.
//

import UIKit

class recentAndSavedCitiesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var myTable: UITableView!
    var cityData:[CityDataModel] = []
    var cities:Set<City> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        myTable.delegate = self
        for city in cities{
            var locationName = city.city + " ,"
            locationName+=city.region
            locationName+=" ,"
            locationName+=city.country
            PhotoIDAPI.shared.functionGetPhotoIDURLRequest(locationName){ [self]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destinationController = segue.destination as? DetailedCityViiewController{
                let city = cityData[self.myTable.indexPathForSelectedRow!.row]
                destinationController.city = city
                destinationController.fromHome = false;
            }
            else{
                return
            }
    }

}
