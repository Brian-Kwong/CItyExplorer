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
        if var name = userDef.string(forKey: "name"){
            userName.text = name
        }
        if var homeCity = userDef.string(forKey: "homeCity"){
            userHomeCity.text = homeCity
        }
    }
    
    @IBAction func pressed(_ sender: Any) {
        print("Hello\n")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userDef = UserDefaults.standard
        let jsonDecoder = JSONDecoder()
        var cities:Set<City> = []
        let userCitiesData:Data?
        if segue.identifier == "Settings"{
            return
        }
        else if segue.identifier == "Recents"{
            userCitiesData = userDef.data(forKey: "recentCities")
            if(userCitiesData == nil){
                popUpAlert("No Recents", "No recents retrieved", "Ok", {_ in })
                return
            }
        }
        else{
            userCitiesData = userDef.data(forKey: "savedCities")
                if(userCitiesData == nil){
                    popUpAlert("No Saved Data", "No saved cities retrieved", "Ok", {_ in })
                    return
                }
        }
        if let citiesArraySet = try? jsonDecoder.decode(Set<City>.self, from:userCitiesData!){
            cities = citiesArraySet
        }
        if let destinationController = segue.destination as? recentAndSavedCitiesViewController{
                destinationController.cities=cities
            }
            else{
                return
            }
    }
    
    func popUpAlert(_ title:String, _ message:String, _ buttonTitle:String,_ action:@escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title:buttonTitle , style: .default, handler: action)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }

}
