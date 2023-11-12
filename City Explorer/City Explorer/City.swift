//
//  City.swift
//  City Explorer
//
//  Created by brian on 11/10/23.
//

import Foundation

struct GPlacesResponse:Codable{
    let candidates:[Place]
}

struct Place:Codable{
    let placeId :String
}

struct PlaceDeta:Codable{
    let result:Results
}

struct Results:Codable{
    let photos:[PhotoRef]
}

struct PhotoRef:Codable{
    let height:Int
    let width:Int
    let photoReference:String
}

struct Response: Codable{
    let data:[City]
}

struct Errors:Codable{
    let code:String
    let message:String
}

struct City: Codable{
    let id:Int
    let wikiDataId:String
    let type:String
    let city:String
    let name:String
    let country:String
    let countryCode:String
    let region: String
    let regionCode:String
    let regionWdId:String
    let latitude:Double
    let longitude:Double
    let population:Int
}

struct Link:Codable{
    let href:String
    let rel:String
}

struct metaData:Codable{
    let currentOffset:Int
    let totalCount:Int
}

enum CodingKeys: String, CodingKey{
    case data
    case links
    case metadata
    case candidates
    case placeId = "place_id"
    case result
    case photos
    case height
    case width
    case photoReference = "photo_reference"
}


struct CityDataModel:Codable{
    let cityInfo:City
    let cityImages:[PhotoRef]
}
