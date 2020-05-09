//
//  Model.swift
//  WeatherSwift
//
//  Created by Gary on 4/30/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


struct WeatherData : Decodable {
    let current: CurrentData
    let daily: [DailyData]
}

struct CurrentData : Decodable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int       // millibars
    let humidity: Double
    let uvi: Double?
    let visibility: Int?     // meters
    let windSpeed: Double
    let windDeg: Double
    let weather: [WeatherInfo]
}

struct WeatherInfo : Decodable {
    let id: Int                 // weather condition: rain, snow, clear, etc.
    let main: String
    let description: String
    let icon: String
}

struct DailyData : Decodable {
    let dt: Int
    let weather: [WeatherInfo]
    let uvi: Double
    let temp: TemperatureInfo
}

struct TemperatureInfo : Decodable {
    let min: Double
    let max: Double
}

