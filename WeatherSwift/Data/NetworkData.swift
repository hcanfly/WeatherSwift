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
            fatalError("Did you enter your AccuWeather API Key?")
          }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                //print(String(bytes: data, encoding: String.Encoding.utf8))
                let jsonDecoder = JSONDecoder()
                //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                //jsonDecoder.dateDecodingStrategy = .iso8601   // secondsSince1970
                do {
                    let theData = try jsonDecoder.decode(T.self, from: data)
                    //DispatchQueue.main.async {
                        completion(theData)
                    //}
                } catch {
                    print("Error parsing JSON")
                    //print(String(bytes: data, encoding: String.Encoding.utf8))
                }
            } else {
                print("Download error: " + error!.localizedDescription)
            }
        }

        task.resume()
    }


    static func getCurrentWeather<T: Decodable>(myType: T.Type, completion: @escaping (T) -> Void) {

        NetworkData.fetch(url: .weather, myType: T.self) { current in
             completion(current)
         }
    }

    static func getForecastWeather<T: Decodable>(myType: T.Type, completion: @escaping (T) -> Void) {

        NetworkData.fetch(url: .forecastWeather, myType: T.self) { current in
             completion(current)
         }
    }

}


let locationCode = "337169"         // Mountain View, CA
let accuWeatherapikey = "<your AccuWeather api key>"  // <your AccuWeather api key>

extension URL {

    static var weather: URL? {
        URL(string: "https://dataservice.accuweather.com/currentconditions/v1/\(locationCode)?apikey=\(accuWeatherapikey)&details=true")
    }

    static var forecastWeather: URL? {
        URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(locationCode)?apikey=\(accuWeatherapikey)&details=true")
    }

}

