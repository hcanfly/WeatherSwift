//
//  NetworkData.swift
//  WeatherSwift
//
//  Created by Gary on 4/30/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation


enum NetworkData {

    static func fetch<T: Decodable>(url: URL?, myType: T.Type, completion: @escaping (T) -> Void) {
          guard let url = url else {
            fatalError("Invalid URL")
          }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                //print(String(bytes: data, encoding: String.Encoding.utf8))
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                //jsonDecoder.dateDecodingStrategy = .iso8601   // secondsSince1970
                do {
                    let theData = try jsonDecoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(theData)
                    }
                } catch {
                    print("Error parsing JSON")
                }
            } else {
                print("Download error: " + error!.localizedDescription)
            }
        }

        task.resume()
    }


    static func getWeather<T: Decodable>(myType: T.Type, completion: @escaping (T) -> Void) {

        NetworkData.fetch(url: .weather, myType: T.self) { current in
             completion(current)
         }
    }

}


let latLong = "lat=37.36&lon=-121.92"
let openweatherapikey = "d568a8ac73574e198b6f9a3be096bdd9"  // <your openweather api key>

extension URL {

    static var weather: URL? {
        URL(string: "https://api.openweathermap.org/data/2.5/onecall?\(latLong)&appid=\(openweatherapikey)&units=imperial")
    }

}

