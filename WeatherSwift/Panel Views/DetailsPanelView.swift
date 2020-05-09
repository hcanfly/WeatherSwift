//
//  DetailsPanelView.swift
//  WeatherSwift
//
//  Created by Gary Hanson on 5/2/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


final class DetailsPanelView : UIView {
    private let condtionsIconView = UIImageView(frame: CGRect.zero)
    private let headerView = PanelHeaderView(title: "Details")
    private let feelsLikeLabel = UILabel()
    private let humidityLabel = UILabel()
    private let visibilityLabel = UILabel()
    private let uvIndexLabel = UILabel()
    private let separator1 = UIView()
    private let separator2 = UIView()
    private let separator3 = UIView()
    private let feelsLikeValueLabel = UILabel()
    private let humidityValueLabel = UILabel()
    private let visibilityValueLabel = UILabel()
    private let uvIndexValue = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor(patternImage: UIImage(named: "PanelBackground")!)
        self.layer.opacity = 0.8
        self.layer.cornerRadius = 6

        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.headerView)

        self.condtionsIconView.contentMode = .scaleAspectFit
        self.condtionsIconView.clipsToBounds = true
        self.condtionsIconView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.condtionsIconView)

        self.feelsLikeLabel.text = "Feels like"
        self.feelsLikeLabel.font = panelFont
        self.feelsLikeLabel.textColor = .white
        self.feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.feelsLikeLabel)

        self.humidityLabel.text = "Humidity"
        self.humidityLabel.font = panelFont
        self.humidityLabel.textColor = .white
        self.humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.humidityLabel)

        self.visibilityLabel.text = "Visibility"
        self.visibilityLabel.font = panelFont
        self.visibilityLabel.textColor = .white
        self.visibilityLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.visibilityLabel)

        self.uvIndexLabel.text = "UV Index"
        self.uvIndexLabel.font = panelFont
        self.uvIndexLabel.textColor = .white
        self.uvIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.uvIndexLabel)

        self.separator1.translatesAutoresizingMaskIntoConstraints = false
        self.separator1.backgroundColor = .white
        self.addSubview(self.separator1)
        self.separator2.translatesAutoresizingMaskIntoConstraints = false
        self.separator2.backgroundColor = .white
        self.addSubview(self.separator2)
        self.separator3.translatesAutoresizingMaskIntoConstraints = false
        self.separator3.backgroundColor = .white
        self.addSubview(self.separator3)

        self.feelsLikeValueLabel.font = panelFont
        self.feelsLikeValueLabel.textColor = .white
        self.feelsLikeValueLabel.textAlignment = .right
        self.feelsLikeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.feelsLikeValueLabel)

        self.humidityValueLabel.font = panelFont
        self.humidityValueLabel.textColor = .white
        self.humidityValueLabel.textAlignment = .right
        self.humidityValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.humidityValueLabel)

        self.visibilityValueLabel.font = panelFont
        self.visibilityValueLabel.textColor = .white
        self.visibilityValueLabel.textAlignment = .right
        self.visibilityValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.visibilityValueLabel)

        self.uvIndexValue.layer.cornerRadius = 6
        self.uvIndexValue.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.uvIndexValue)

        self.reloadData()
        self.setupContraints()
    }
    
    func reloadData() {
        self.condtionsIconView.image = ViewModel.shared.weatherIcon

        self.feelsLikeValueLabel.text = ViewModel.shared.feelsLike
        self.humidityValueLabel.text = ViewModel.shared.humidity
        self.visibilityValueLabel.text = ViewModel.shared.visibility
        self.uvIndexValue.backgroundColor = ViewModel.shared.uvIndexColor
    }
    
    private func setupContraints() {
        let centerOffset: CGFloat = 30
        let trailingOffset: CGFloat = -60

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            self.headerView.heightAnchor.constraint(equalToConstant: 40),
            self.headerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),

            self.condtionsIconView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -14),
            self.condtionsIconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.condtionsIconView.heightAnchor.constraint(equalToConstant: 130),
            self.condtionsIconView.widthAnchor.constraint(equalToConstant: 130),

            self.feelsLikeLabel.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -4),
            self.feelsLikeLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: centerOffset),
            self.feelsLikeLabel.heightAnchor.constraint(equalToConstant: 30),

            self.feelsLikeValueLabel.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -4),
            self.feelsLikeValueLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingOffset),
            self.feelsLikeValueLabel.heightAnchor.constraint(equalToConstant: 30),
            self.feelsLikeValueLabel.widthAnchor.constraint(equalToConstant: 56),

            self.separator1.topAnchor.constraint(equalTo: self.feelsLikeLabel.bottomAnchor, constant: 0),
            self.separator1.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: centerOffset),
            self.separator1.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            self.separator1.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),  //FIXME!!

            self.humidityLabel.topAnchor.constraint(equalTo: self.separator1.bottomAnchor, constant: 0),
            self.humidityLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: centerOffset),
            self.humidityLabel.heightAnchor.constraint(equalToConstant: 30),

            self.humidityValueLabel.topAnchor.constraint(equalTo: self.separator1.bottomAnchor, constant: -4),
            self.humidityValueLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingOffset),
            self.humidityValueLabel.heightAnchor.constraint(equalToConstant: 30),
            self.humidityValueLabel.widthAnchor.constraint(equalToConstant: 56),

            self.separator2.topAnchor.constraint(equalTo: self.humidityLabel.bottomAnchor, constant: 0),
            self.separator2.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: centerOffset),
            self.separator2.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            self.separator2.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),  //FIXME!!

            self.visibilityLabel.topAnchor.constraint(equalTo: self.separator2.bottomAnchor, constant: 0),
            self.visibilityLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: centerOffset),
            self.visibilityLabel.heightAnchor.constraint(equalToConstant: 30),

            self.visibilityValueLabel.topAnchor.constraint(equalTo: self.separator2.bottomAnchor, constant: -4),
            self.visibilityValueLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingOffset),
            self.visibilityValueLabel.heightAnchor.constraint(equalToConstant: 30),
            self.visibilityValueLabel.widthAnchor.constraint(equalToConstant: 56),

            self.separator3.topAnchor.constraint(equalTo: self.visibilityLabel.bottomAnchor, constant: 0),
            self.separator3.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: centerOffset),
            self.separator3.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            self.separator3.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),  //FIXME!!

            self.uvIndexLabel.topAnchor.constraint(equalTo: self.separator3.bottomAnchor, constant: 0),
            self.uvIndexLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: centerOffset),
            self.uvIndexLabel.heightAnchor.constraint(equalToConstant: 30),

            self.uvIndexValue.topAnchor.constraint(equalTo: self.separator3.bottomAnchor, constant: 10),
            self.uvIndexValue.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36),
            self.uvIndexValue.heightAnchor.constraint(equalToConstant: 10),
            self.uvIndexValue.widthAnchor.constraint(equalToConstant: 30),

            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
