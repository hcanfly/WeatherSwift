//
//  ViewModel.swift
//  WeatherSwift
//
//  Created by Gary on 5/3/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


final class ViewModel {
    var data = WeatherData(current: CurrentData(dt: 2342342, sunrise: 686879, sunset: 98686, temp: 0, feelsLike: 0, pressure: 0, humidity: 0, uvi: 0.0, visibility: 0, windSpeed: 0.0, windDeg: 0, weather: [WeatherInfo(id: 42, main: "", description: "", icon: "")]), daily: [DailyData(dt: 6, weather: [WeatherInfo(id: 42, main: "", description: "", icon: "")], uvi: 0.0, temp: TemperatureInfo(min: 0, max: 0))])

    static let shared = ViewModel()

    private init() { }


    //MARK: - Current Conditions view
    var temperature: String {
        return doubleToRoundedString(dbl: self.data.current.temp)
    }

    var currentConditions: String {
        return currentWeatherInfo.description.capitalizingFirstLetter()
    }

    // the high and low temps are frequently going to be wrong. Mostly at night.
    // openweather doesn't have a real min and max for the day. You can now get
    // historical data, EXCEPT for the previous six hours. So there is no way to
    // even calculate it from their data.
    // So, if this was anything but a sample app I would either find another data
    // source (but I can't find anything else now that DarkSky is gone), or just
    // not show the info. But, this is a sample app, and it is often at least fairly
    // close, so I'm showing what I can get because if this was a real app, there
    // would be better data and a real app would show the day's high and low.
    var highTemp: String {
        return doubleToRoundedString(dbl: ViewModel.shared.data.daily[0].temp.max)
    }

    var lowTemp: String {
        return doubleToRoundedString(dbl: ViewModel.shared.data.daily[0].temp.min)
    }

    //MARK: -  Details panel
    var feelsLike: String {
        return doubleToRoundedString(dbl: self.data.current.feelsLike) + degreeChar
    }

    var uvIndexColor: UIColor {
        return self.data.current.uvi != nil ? UVIndex(value: Int(self.data.current.uvi!.rounded())).color : .blue
     }

    var humidity: String {
        return doubleToRoundedString(dbl: self.data.current.humidity) + "%"
    }

    var visibility: String {
        return metersToMilesString(meters: self.data.current.visibility)
    }

    //MARK: -  Wind and Pressure panel
    var windSpeedString: String {
        return doubleToRoundedString(dbl: self.data.current.windSpeed)
    }

    var windSpeed: Double {
        return self.data.current.windSpeed
    }

    var windDirection: String {
        return getWindDirection(degrees: self.data.current.windDeg)
    }
    
    var windInfo: String {
        return self.windSpeedString + " mph " + self.windDirection
    }

    var pressure: String {
        return millibarsToInchesString(millibars: self.data.current.pressure)
    }

    //MARK: -  used in a couple of places
    var currentWeatherInfo: WeatherInfo {
        return self.data.current.weather[0]
    }

    var iconURLString: String {
        return urlString(for: self.currentWeatherInfo.icon)
    }

    //MARK: -  Forecast panel
    func forecastInfo() -> [ForecastInfo] {
        var forecast = [ForecastInfo]()

        for index in 0...4 {
            let dailyInfo = self.data.daily[index]

            let dowString = dowFrom(date: dailyInfo.dt)
            let url = urlString(for: dailyInfo.weather[0].icon)
            let min = doubleToRoundedString(dbl: dailyInfo.temp.min) + degreeChar
            let max = doubleToRoundedString(dbl: dailyInfo.temp.max) + degreeChar
            forecast.append(ForecastInfo(dow: dowString, iconURLString: url, min: min, max: max))
            }

        return forecast
    }
}

struct ForecastInfo {
    let dow: String
    let iconURLString: String
    let min: String
    let max: String
}


//MARK: utilities for formatting data

fileprivate func urlString(for icon: String) -> String {
    return "http://openweathermap.org/img/wn/\(icon)@2x.png"
}

fileprivate func millibarsToInchesString(millibars: Int?) -> String {
      guard let millibars = millibars else {
          return "0.00 in."
      }

    let inches = Double(millibars) * 0.0295301

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
