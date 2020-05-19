//
//  ViewModel.swift
//  WeatherSwift
//
//  Created by Gary on 5/3/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


final class ViewModel {

    var current = CurrentData(LocalObservationDateTime: "", EpochTime: 23423434, WeatherText: "", WeatherIcon: 7, PrecipitationType: nil, IsDayTime: true, Temperature: ImperialInfo(Imperial: AccuValue(Value: 55, Unit: "F")), RealFeelTemperature: ImperialInfo(Imperial: AccuValue(Value: 60, Unit: "F")), RelativeHumidity: 22, Wind: WindInfo(Direction: DirectionDetail(Degrees: 268, Localized: "NW"), Speed: ImperialInfo(Imperial: AccuValue(Value: 6, Unit: "mph"))), UVIndex: 4, Visibility: ImperialInfo(Imperial: AccuValue(Value: 10, Unit: "mi")), Pressure: ImperialInfo(Imperial: AccuValue(Value: 29.81, Unit: "inHg")), ApparentTemperature: ImperialInfo(Imperial: AccuValue(Value: 64.0, Unit: "F")), WindChillTemperature: ImperialInfo(Imperial: AccuValue(Value: 55.5, Unit: "F")))

    var forecast = ForecastData(DailyForecasts: [DailyData(Date: "", EpochDate: 789798, Temperature: ForecastTemperatureInfo(Minimum: AccuValue(Value: 50, Unit: "F"), Maximum: AccuValue(Value: 88, Unit: "F")), Day: ConditionsInfo(Icon: 6, IconPhrase: ""))])

    static let shared = ViewModel()

    private init() { }


    //MARK: - Current Conditions view
    var temperature: String {
        return doubleToRoundedString(dbl: self.current.Temperature.Imperial.Value)
    }

    var currentConditions: String {
        return self.current.WeatherText
    }

    var highTemp: String {
        return doubleToRoundedString(dbl: ViewModel.shared.forecast.DailyForecasts[0].Temperature.Maximum.Value)
    }

    var lowTemp: String {
        return doubleToRoundedString(dbl: ViewModel.shared.forecast.DailyForecasts[0].Temperature.Minimum.Value)
    }

    var weatherIcon: UIImage? {
        return getWeatherIcon(icon: self.current.WeatherIcon)
    }

    func getWeatherIcon(icon: Int) -> UIImage {
        var iconString = ""
        if icon < 10 {
            iconString += "0\(icon)"
        } else {
            iconString += "\(icon)"
        }
        iconString += "-s.png"

        return UIImage(named: iconString)!
    }

    var isRaining: Bool {
        self.current.PrecipitationType != nil && self.current.PrecipitationType == "Rain"
    }

    //MARK: -  Details panel
    var feelsLike: String {
        return doubleToRoundedString(dbl: self.current.ApparentTemperature.Imperial.Value) + degreeChar
    }

    var uvIndexColor: UIColor {
        return self.current.UVIndex != nil ? UVIndex(value: self.current.UVIndex!).color : .blue
     }

    var humidity: String {
        return self.current.RelativeHumidity != nil ? "\(self.current.RelativeHumidity!)" + "%" : "n/a"
    }

    var visibility: String {
        return doubleToRoundedString(dbl: self.current.Visibility.Imperial.Value) + " mi"
    }

    //MARK: -  Wind and Pressure panel
    var windSpeedString: String {
        return doubleToRoundedString(dbl: self.current.Wind.Speed.Imperial.Value)
    }

    var windSpeed: Double {
        return self.current.Wind.Speed.Imperial.Value
    }

    var windDirection: String {
        return self.current.Wind.Direction.Localized
    }
    
    var windInfo: String {
        return self.windSpeedString + " mph " + self.windDirection
    }

    var pressure: String {
        return pressureInInchesString(inches: self.current.Pressure.Imperial.Value)
    }

    //MARK: -  Forecast panel
    func forecastInfo() -> [ForecastInfo] {
        var forecast = [ForecastInfo]()

        for index in 0...4 {
            let dailyInfo = self.forecast.DailyForecasts[index]

            let dowString = dowFrom(date: dailyInfo.EpochDate)
            let icon = getWeatherIcon(icon: dailyInfo.Day.Icon)
            let min = doubleToRoundedString(dbl: dailyInfo.Temperature.Minimum.Value) + degreeChar
            let max = doubleToRoundedString(dbl: dailyInfo.Temperature.Maximum.Value) + degreeChar
            forecast.append(ForecastInfo(dow: dowString, icon: icon, min: min, max: max))
            }

        return forecast
    }
}

struct ForecastInfo {
    let dow: String
    let icon: UIImage
    let min: String
    let max: String
}


//MARK: utilities for formatting data

fileprivate func millibarsToInchesString(millibars: Int?) -> String {
      guard let millibars = millibars else {
          return "0.00 in."
      }

    let inches = Double(millibars) * 0.0295301

    return String(format: "%.1f", inches) + " in."
}

fileprivate func pressureInInchesString(inches: Double) -> String {

    return String(format: "%.1f", inches) + " in."
}

fileprivate func metersToMilesString(meters: Int?) -> String {
    guard let meters = meters else {
        return "n/a"
    }

    let miles = Double(meters) / 1609.34
    return "\(Int(miles.rounded()))" + " mi"
}

fileprivate enum UVIndex {
    case high
    case medium
    case mediumHigh
    case low

    // US EPA index
    init(value: Int) {
        switch value {
            case 0...2:
                self = .low
            case 3...5:
                self = .medium
            case 6...7:
                self = .mediumHigh
            default:
                self = .high
        }
    }

    var color: UIColor {
        switch self {
            case .high:
                return .red
            case .mediumHigh:
                return .orange
            case .medium:
                return .yellow
            case .low:
                return .green
        }
    }
}

fileprivate func getWindDirection(degrees: Double?) -> String {
  var dir = "N"

    guard let degrees = degrees else {
        return dir
    }

  if (degrees > 340) {
    dir = "N"
  } else if (degrees > 290) {
    dir = "NW"
  } else if (degrees > 250) {
    dir = "W"
  } else if (degrees > 200) {
    dir = "SW"
  } else if (degrees > 160) {
    dir = "S"
  } else if (degrees > 110) {
    dir = "SE"
  } else if (degrees > 70) {
    dir = "E"
  } else if (degrees > 20) {
    dir = "NE"
  }

  return dir
}

fileprivate func doubleToRoundedString(dbl: Double?) -> String {
    guard let dbl = dbl, dbl != 0.0 else {
        return ""
    }

    return "\(Int(dbl.rounded()))"
}

fileprivate extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

fileprivate func dateToString(date: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(date))
    let formatter = DateFormatter()

    formatter.dateFormat = "MMM dd, YYYY"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.locale = NSLocale.current

    let updatedDateStr = formatter.string(from: date)
    return updatedDateStr
}

fileprivate func dowFrom(date: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(date))
    let formatter = DateFormatter()

    formatter.dateFormat = "EEEE"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.locale = NSLocale.current

    let dow = formatter.string(from: date)
    return dow
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha )
    }
}
