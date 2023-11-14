//
//  CityTableView.swift
//  City Explorer
//
//  Created by brian on 11/11/23.
//

import Nuke
import UIKit

class CityTableView: UITableViewCell {
    @IBOutlet var CityImage: UIImageView!

    @IBOutlet var CityName: UILabel!

    @IBOutlet var CityCountry: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ city: CityDataModel) {
        CityName.text = city.cityInfo.city
        CityCountry.text = city.cityInfo.country
        if let photo = city.cityImages.first {
            let urlString = PhotoAPI.buildImageURL(photo)
            let image = URL(string: urlString)!
            Nuke.loadImage(with: image, into: CityImage)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
