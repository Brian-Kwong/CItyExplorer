//
//  API Processor.swift
//  City Explorer
//
//  Created by brian on 11/10/23.
//

import Foundation

final class CityAPI{
    
    
    private init(){
        /*Blank*/
    }
    
    static let shared = CityAPI()
    
    func functionGetCityURLRequest(completion: @escaping (Result<[City],Error>) -> Void){
        let headers = [
            "X-RapidAPI-Key": "e83ef242camshcf5494f13f3b17cp17debejsnc310b5f6fce9",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]
        let baseURL = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?limit=10&location=%2B37.77-122.4326"
        let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL);
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest){
           data, response,error in
            guard error == nil else{return}
            guard data != nil else{return}
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            do{
                let responseData = try decoder.decode(Response.self, from: data!)
                completion(.success(responseData.data))
            }
            catch{
                completion(.failure(error))
            }
        }.resume()
    }
}

final class PhotoIDAPI{
    
    
    private init(){
        /*Blank*/
    }
    
    static let shared = PhotoIDAPI()
    
    func functionGetPhotoIDURLRequest(_ location:String, completion: @escaping (Result<String,Error>) -> Void){
        let baseURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?inputtype=textquery&key=AIzaSyA347e3-Var0rEuVTYTNwl2v-wwOF7uB80&fields=place_id&input="
        
        var myURL = URL(string: baseURL+location)!
        print(myURL)
        var myRequest = URLRequest(url: myURL)
        URLSession.shared.dataTask(with: myRequest){
           data, response,error in
            guard error == nil else{return}
            guard data != nil else{return}
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do{
                let responseData = try decoder.decode(GPlacesResponse.self, from: data!)
                completion(.success(responseData.candidates.first!.placeId))
            }
            catch{
                completion(.failure(error))
            }
        }.resume()
    }
}

final class PhotoAPI{
    
    
    private init(){
        /*Blank*/
    }
    
    static let shared = PhotoAPI()
    
    func functionGetPhotoRefURLRequest(_ placeID:String, completion: @escaping (Result<[PhotoRef],Error>) -> Void){
        let baseURL = "https://maps.googleapis.com/maps/api/place/details/json?&key=AIzaSyA347e3-Var0rEuVTYTNwl2v-wwOF7uB80&fields=photos&place_id="
        
        let myURL = URL(string: baseURL+placeID)!
        let myRequest = URLRequest(url: myURL)
        URLSession.shared.dataTask(with: myRequest){
           data, response,error in
            guard error == nil else{return}
            guard data != nil else{return}
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do{
                let responseData = try decoder.decode(PlaceDeta.self, from: data!)
                completion(.success(responseData.result.photos))
            }
            catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func buildImageURL(_ photo:PhotoRef)->String{
        let baseURL:String = "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyA347e3-Var0rEuVTYTNwl2v-wwOF7uB80"
        var url = baseURL + "&photoreference="
        url+=photo.photoReference
        url+="&maxwidth="
        url+=String(photo.width)
        url+="&maxheight="
        url+=String(photo.height)
        return url
    }
}


