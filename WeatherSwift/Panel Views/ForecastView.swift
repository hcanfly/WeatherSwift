//
//  ForecastView.swift
//  WeatherSwift
//
//  Created by Gary Hanson on 5/2/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//



import UIKit


final class ForecastView : UIView {
    private let headerView = PanelHeaderView(title: "Forecast")
    private var forecastViews = [ForecastDayView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.backgroundColor = UIColor(patternImage: UIImage(named: "PanelBackground")!)
        self.layer.opacity = 0.8
        self.layer.cornerRadius = 6
        self.translatesAutoresizingMaskIntoConstraints = false

        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.clipsToBounds = true
        self.addSubview(self.headerView)

        for index in 0...4 {
            self.forecastViews.append(ForecastDayView())
            self.forecastViews[index].translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.forecastViews[index])
        }
        
        self.setupContraints()
    }
    
    private func setupContraints() {
        
        for index in 0...4 {
            self.forecastViews[index].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            self.forecastViews[index].heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.forecastViews[index].widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        }

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            self.headerView.heightAnchor.constraint(equalToConstant: 40),
            self.headerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),

            self.forecastViews[0].topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -5),
            self.forecastViews[1].topAnchor.constraint(equalTo: self.forecastViews[0].bottomAnchor, constant: 0),
            self.forecastViews[2].topAnchor.constraint(equalTo: self.forecastViews[1].bottomAnchor, constant: 0),
            self.forecastViews[3].topAnchor.constraint(equalTo: self.forecastViews[2].bottomAnchor, constant: 0),
            self.forecastViews[4].topAnchor.constraint(equalTo: self.forecastViews[3].bottomAnchor, constant: 0),
        ])

    }

    func reloadData() {
        let info = ViewModel.shared.forecastInfo()
        for index in 0...4 {
            self.forecastViews[index].info = info[index]
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
