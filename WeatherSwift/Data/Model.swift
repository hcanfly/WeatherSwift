//
//  Model.swift
//  WeatherSwift
//
//  Created by Gary on 4/30/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


struct AccuValue : Decodable {
    let Value: Double
    let Unit: String
}

struct ImperialInfo : Decodable {
    let Imperial: AccuValue           // also has Metric
}

struct DirectionDetail : Decodable {
    let Degrees: Int
    let Localized: String
}

struct WindSpeed : Decodable {
    let Imperial: AccuValue
}

struct WindInfo : Decodable {
    let Direction: DirectionDetail
    let Speed: ImperialInfo
}

struct CurrentData : Decodable {
    let LocalObservationDateTime: String
    let EpochTime: Int
    let WeatherText: String
    let WeatherIcon: Int
    let PrecipitationType: String?          // check for "Rain" if not nil
    let IsDayTime: Bool
    let Temperature: ImperialInfo
    let RealFeelTemperature: ImperialInfo   // "Patented AccuWeather RealFeel Temperature"
    let RelativeHumidity: Int?
    let Wind: WindInfo
    let UVIndex: Int?
    let Visibility: ImperialInfo
    let Pressure: ImperialInfo
    let ApparentTemperature: ImperialInfo
    let WindChillTemperature: ImperialInfo
}


struct ForecastTemperatureInfo : Decodable {
    let Minimum: AccuValue
    let Maximum: AccuValue
}

struct ConditionsInfo : Decodable {
    let Icon: Int
    let IconPhrase: String
}

struct DailyData : Decodable {
    let Date: String
    let EpochDate: Int
    let Temperature: ForecastTemperatureInfo
    let Day: ConditionsInfo
}

struct ForecastData : Decodable {
    let DailyForecasts : [DailyData]
}
