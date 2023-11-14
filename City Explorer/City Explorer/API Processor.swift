//
//  API Processor.swift
//  City Explorer
//
//  Created by brian on 11/10/23.
//

import Foundation

let apiKey = "&key=AIzaSyA347e3-Var0rEuVTYTNwl2v-wwOF7uB80"
let rapidApiKey = "e83ef242camshcf5494f13f3b17cp17debejsnc310b5f6fce9"

final class CityAPI {
    private init() {
        /* Blank */
    }

    static let shared = CityAPI()

    func functionGetCityURLRequest(_ location: Location, completion: @escaping (Result<[City], Error>) -> Void) {
        let headers = [
            "X-RapidAPI-Key": rapidApiKey,
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
        ]
        var baseURL = "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?limit=10&types=CITY&sort=-population"
        if location.name.isEmpty {
            baseURL += "&location=%2B"
            baseURL += String(location.lat)
            baseURL += String(location.long)
        } else {
            baseURL += "&namePrefix="
            baseURL += location.name
            baseURL += "&namePrefixDefaultLangResults=false"
        }
        let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request as URLRequest) {
            data, _, error in
            guard error == nil else { completion(.failure(error!))
                return
            }
            guard data != nil else { completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            do {
                let responseData = try decoder.decode(Response.self, from: data!)
                completion(.success(responseData.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class PhotoIDAPI {
    private init() {
        /* Blank */
    }

    static let shared = PhotoIDAPI()

    func functionGetPhotoIDURLRequest(_ location: String, completion: @escaping (Result<String, Error>) -> Void) {
        var baseURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?inputtype=textquery&fields=place_id&input="
        baseURL += location
        var myURL = URL(string: baseURL + apiKey)!
        var myRequest = URLRequest(url: myURL)
        URLSession.shared.dataTask(with: myRequest) {
            data, _, error in
            guard error == nil else { completion(.failure(error!))
                return
            }
            guard data != nil else { completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseData = try decoder.decode(GPlacesResponse.self, from: data!)
                if responseData.candidates.first != nil {
                    completion(.success(responseData.candidates.first!.placeId))
                } else {
                    completion(.success(""))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class PhotoAPI {
    private init() {
        /* Blank */
    }

    static let shared = PhotoAPI()

    func functionGetPhotoRefURLRequest(_ placeID: String, completion: @escaping (Result<[PhotoRef], Error>) -> Void) {
        var baseURL = "https://maps.googleapis.com/maps/api/place/details/json?fields=photos&place_id="

        let photoRef = PhotoRef(height: 400, width: 400, photoReference: "ATJ83zhSSAtkh5LTozXMhBghqubeOxnZWUV2m7Hv2tQaIzKQJgvZk9yCaEjBW0r0Zx1oJ9RF1G7oeM34sQQMOv8s2zA0sgGBiyBgvdyMxeVByRgHUXmv-rkJ2wyvNv17jyTSySm_-_6R2B0v4eKX257HOxvXlx_TSwp2NrICKrZM2d5d2P4q")
        let placeHolder: [PhotoRef] = [photoRef]

        if placeID.isEmpty {
            completion(.success(placeHolder))
        }
        baseURL += placeID
        let myURL = URL(string: baseURL + apiKey)!
        let myRequest = URLRequest(url: myURL)
        URLSession.shared.dataTask(with: myRequest) {
            data, _, error in
            guard error == nil else { completion(.success(placeHolder))
                return
            }
            guard data != nil else { completion(.success(placeHolder))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseData = try decoder.decode(PlaceDeta.self, from: data!)
                completion(.success(responseData.result.photos))
            } catch {
                completion(.success(placeHolder))
            }
        }.resume()
    }

    static func buildImageURL(_ photo: PhotoRef) -> String {
        let baseURL = "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyA347e3-Var0rEuVTYTNwl2v-wwOF7uB80"
        var url = baseURL + "&photoreference="
        url += photo.photoReference
        url += "&maxwidth="
        url += String(photo.width)
        url += "&maxheight="
        url += String(photo.height)
        return url
    }
}

final class cityAutoComplete {
    private init() {
        /* Blank */
    }

    static let shared = cityAutoComplete()

    func functionGetCityFromSearchRequest(_ location: String, completion: @escaping (Result<String, Error>) -> Void) {
        var baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?types=%28cities%29&feilds=description&input="
        baseURL += location
        let myURL = URL(string: baseURL + apiKey)!
        let myRequest = URLRequest(url: myURL)
        URLSession.shared.dataTask(with: myRequest) {
            data, _, error in
            guard error == nil else { completion(.failure(error!))
                return
            }
            guard data != nil else { completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseData = try decoder.decode(cityPredictionResponse.self, from: data!)
                if responseData.status == "OK" {
                    completion(.success(responseData.predictions.first!.structuredFormatting.mainText))
                } else {
                    completion(.success(""))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
