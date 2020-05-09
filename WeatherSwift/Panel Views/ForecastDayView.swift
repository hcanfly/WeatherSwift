//
//  ForecastDayView.swift
//  WeatherSwift
//
//  Created by Gary on 5/6/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit

final class ForecastDayView : UIView {
    private let dowLabel = UILabel()
    private let conditionIconView = UIImageView(frame: CGRect.zero)
    private let highTempLabel = UILabel()
    private let lowTempLabel = UILabel()
    private let separator = UIView()

    var info: ForecastInfo? {
        didSet {
            self.updateValues()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        self.dowLabel.font = panelFont
        self.dowLabel.textColor = .white
        self.dowLabel.textAlignment = .left
        self.dowLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.dowLabel)

        self.highTempLabel.font = panelFont
        self.highTempLabel.textColor = .white
        self.highTempLabel.textAlignment = .left
        self.highTempLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.highTempLabel)

        self.lowTempLabel.font = panelFont
        self.lowTempLabel.textColor = .white
        self.lowTempLabel.textAlignment = .right
        self.lowTempLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.lowTempLabel)

        self.conditionIconView.contentMode = .scaleAspectFit
        self.conditionIconView.clipsToBounds = true
        self.conditionIconView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.conditionIconView)

        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.backgroundColor = .white
        self.addSubview(self.separator)

        self.setupContraints()
    }

    private func setupContraints() {

        NSLayoutConstraint.activate([
            self.dowLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.dowLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            self.dowLabel.heightAnchor.constraint(equalToConstant: 40),
            self.dowLabel.widthAnchor.constraint(equalToConstant: 100),

            self.conditionIconView.topAnchor.constraint(equalTo: self.topAnchor),
            self.conditionIconView.leadingAnchor.constraint(equalTo: self.dowLabel.trailingAnchor, constant: 60),
            self.conditionIconView.heightAnchor.constraint(equalToConstant: 40),
            self.conditionIconView.widthAnchor.constraint(equalToConstant: 40),

            self.highTempLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.highTempLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -88),
            self.highTempLabel.heightAnchor.constraint(equalToConstant: 40),
            self.highTempLabel.widthAnchor.constraint(equalToConstant: 40),

            self.lowTempLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.lowTempLabel.leadingAnchor.constraint(equalTo: self.highTempLabel.trailingAnchor, constant: 10),
            self.lowTempLabel.heightAnchor.constraint(equalToConstant: 40),
            self.lowTempLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  -4),

            self.separator.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            self.separator.leadingAnchor.constraint(equalTo: self.dowLabel.leadingAnchor, constant: 0),
            self.separator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            self.separator.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),  //FIXME!!
        ])
    }

    private func updateValues() {
        self.dowLabel.text = info!.dow
        self.conditionIconView.image = info!.icon
        self.highTempLabel.text = info!.max
        self.lowTempLabel.text = info!.min
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
