//
//  FetchWeatherOperations.swift
//  WeatherSwift
//
//  Created by Gary on 5/19/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation

public final class FetchCurrentWeatherOperation: AsyncOperation {

    override final public func main() {

        NetworkData.getCurrentWeather(myType: [CurrentData].self)  { [weak self] current in
            if current.count > 0 {
                ViewModel.shared.current = current.first!
            }
            self?.finish()
        }
    }
}


public final class FetchForecastWeatherOperation: AsyncOperation {

    override final public func main() {

        NetworkData.getForecastWeather(myType: ForecastData.self)  { [weak self] forecast in
            ViewModel.shared.forecast = forecast
            self?.finish()
        }
    }
}
