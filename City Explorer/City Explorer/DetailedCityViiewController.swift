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

    
    
 
    @IBOutlet var DetailedImageView: UIImageView!
    
    
 
    @IBOutlet var CityName: UILabel!
    
    
 
    @IBOutlet var CountryName: UILabel!
    
    

   
    @IBOutlet var PopulationName: UILabel!
    
   
    
    @IBOutlet var RegionName: UILabel!
    
 
    @IBOutlet var LongInfo: UILabel!
    
    
    @IBOutlet var LatInfo: UILabel!
    
    
    @IBOutlet var WikiIDButton: UIButton!
    
    var city:CityDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
