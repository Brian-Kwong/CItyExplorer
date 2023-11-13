//
//  DetailedCityViiewController.swift
//  City Explorer
//
//  Created by brian on 11/11/23.
//

import UIKit
import Nuke
import SafariServices

class DetailedCityViiewController: UIViewController, SFSafariViewControllerDelegate {

    
    let userDef = UserDefaults.standard
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
 
    @IBOutlet var DetailedImageView: UIImageView!
    
    
 
    @IBOutlet var CityName: UILabel!
    
    
 
    @IBOutlet var CountryName: UILabel!
    
    

   
    @IBOutlet var PopulationName: UILabel!
    
   
    
    @IBOutlet var RegionName: UILabel!
    
 
    @IBOutlet var LongInfo: UILabel!
    
    
    @IBOutlet var LatInfo: UILabel!
    
    
    @IBOutlet var WikiIDButton: UIButton!
    
    @IBOutlet var savedButton: UIButton!
    
    
    var city:CityDataModel!
    
    var savedCities:Set<City> = []
    
    var saved:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saved = inSave()
        if(saved){
            savedButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        addToRecents()
        CityName.text = city.cityInfo.city
        CountryName.text = city.cityInfo.country
        PopulationName.text = String(city.cityInfo.population)
        RegionName.text = city.cityInfo.region
        LongInfo.text = String(city.cityInfo.longitude)
        LatInfo.text = String(city.cityInfo.latitude)
        WikiIDButton.setTitle(city.cityInfo.wikiDataId, for: .normal)
        if let photo = city.cityImages.first{
            let urlString = PhotoAPI.buildImageURL(photo)
            let image = URL(string: urlString)!
            Nuke.loadImage(with: image, into: DetailedImageView)
        }
    }
    

    @IBAction func goToSelectedWikiPage(_ sender: UIButton) {
        let baseURL = "https://www.wikidata.org/wiki/"
        let safariWindow = SFSafariViewController(url:URL(string: baseURL+city.cityInfo.wikiDataId)!)
        self.present(safariWindow, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
    
    
    @IBAction func saveThisCity(_ sender: UIButton) {
        let buttonImage:UIImage?
        saved = !saved
        if(saved){
            buttonImage = UIImage(systemName: "star.fill")
            savedCities.insert(city.cityInfo)
        }
        else{
            buttonImage = UIImage(systemName: "star")
            savedCities.remove(city.cityInfo)
        }
        sender.setImage(buttonImage, for: .normal)
        if let userSavedtCityData = try? jsonEncoder.encode(savedCities){
            userDef.setValue(userSavedtCityData, forKey: "savedCities")
        }
    }
    
    func inSave()->Bool{
        if let userSavedCitiesData = userDef.data(forKey: "savedCities"){
            if let savedCitiesSet = try? jsonDecoder.decode(Set<City>.self, from:userSavedCitiesData){
                self.savedCities = savedCitiesSet
            }
        }
        return savedCities.contains(city.cityInfo)
    }
    
    
    func addToRecents()->Void{
        var recentCities:Set<City> = []
        if let userRecentCity = userDef.data(forKey: "recentCities"){
            if let recentCitiesSet = try? jsonDecoder.decode(Set<City>.self, from:userRecentCity){
                recentCities = recentCitiesSet
            }
        }
        recentCities.insert(city.cityInfo)
        if let userRecentCityData = try? jsonEncoder.encode(recentCities){
            userDef.setValue(userRecentCityData, forKey: "recentCities")
        }
    }

}
