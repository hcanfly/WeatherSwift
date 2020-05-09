//
//  CurrentConditionsView.swift
//  WeatherSwift
//
//  Created by Gary on 5/2/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit

let degreeChar = "°"

final class CurrentConditionsView : UIView {

    private let condtionsIconView = UIImageView(frame: CGRect.zero)
    private let conditionsDescription = UILabel()
    private let highTempIconView = UIImageView()
    private let lowTempIconView = UIImageView()
    private let lowTempLabel = UILabel()
    private let highTempLabel = UILabel()
    private let currentTempLabel = UILabel()


    override init(frame: CGRect) {
        super.init(frame: frame)

        self.condtionsIconView.contentMode = .scaleAspectFit
        self.condtionsIconView.clipsToBounds = true
        self.condtionsIconView.translatesAutoresizingMaskIntoConstraints = false

        self.highTempIconView.image = UIImage(named: "PrimaryInfo_high")
        self.highTempIconView.contentMode = .scaleAspectFit
        self.highTempIconView.translatesAutoresizingMaskIntoConstraints = false

        self.lowTempIconView.image = UIImage(named: "PrimaryInfo_low")
        self.lowTempIconView.contentMode = .scaleAspectFit
        self.lowTempIconView.translatesAutoresizingMaskIntoConstraints = false

        self.conditionsDescription.font = UIFont.preferredFont(forTextStyle: .body)
        self.conditionsDescription.textColor = .white
        self.conditionsDescription.translatesAutoresizingMaskIntoConstraints = false

        self.highTempLabel.textColor = .white
        self.highTempLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.highTempLabel.translatesAutoresizingMaskIntoConstraints = false

        self.lowTempLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.lowTempLabel.textColor = .white
        self.lowTempLabel.translatesAutoresizingMaskIntoConstraints = false

        self.currentTempLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        self.currentTempLabel.textColor = .white
        self.currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTempLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-UltraLight", size: 72)!)
        currentTempLabel.adjustsFontForContentSizeCategory = true

        self.addSubview(self.condtionsIconView)
        self.addSubview(self.conditionsDescription)
        self.addSubview(self.highTempIconView)
        self.addSubview(self.highTempLabel)
        self.addSubview(self.lowTempIconView)
        self.addSubview(self.lowTempLabel)
        self.addSubview(self.currentTempLabel)

        self.reloadData()
        self.setupContraints()
    }
    
    func reloadData() {
        self.condtionsIconView.image = ViewModel.shared.weatherIcon
        self.conditionsDescription.text = ViewModel.shared.currentConditions
        self.conditionsDescription.sizeToFit()
        self.highTempLabel.text = ViewModel.shared.highTemp + degreeChar
        self.highTempLabel.sizeToFit()
        self.lowTempLabel.text = ViewModel.shared.lowTemp + degreeChar
        self.lowTempLabel.sizeToFit()
        self.currentTempLabel.text = ViewModel.shared.temperature + degreeChar
        self.currentTempLabel.sizeToFit()
    }


    private func setupContraints() {

        NSLayoutConstraint.activate([
            self.condtionsIconView.topAnchor.constraint(equalTo: self.topAnchor),
            self.condtionsIconView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.condtionsIconView.heightAnchor.constraint(equalToConstant: 50),
            self.condtionsIconView.widthAnchor.constraint(equalToConstant: 50),

            self.conditionsDescription.topAnchor.constraint(equalTo: self.topAnchor),
            self.conditionsDescription.leadingAnchor.constraint(equalTo: self.condtionsIconView.trailingAnchor),
            self.conditionsDescription.bottomAnchor.constraint(equalTo: self.condtionsIconView.bottomAnchor),

            self.highTempIconView.topAnchor.constraint(equalTo: self.conditionsDescription.bottomAnchor),
            self.highTempIconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.highTempIconView.widthAnchor.constraint(equalToConstant: 12),

            self.highTempLabel.topAnchor.constraint(equalTo: self.highTempIconView.topAnchor, constant: -4),
            self.highTempLabel.leadingAnchor.constraint(equalTo: self.highTempIconView.trailingAnchor, constant: 6),

            self.lowTempIconView.topAnchor.constraint(equalTo: self.highTempIconView.topAnchor),
            self.lowTempIconView.leadingAnchor.constraint(equalTo: self.highTempLabel.trailingAnchor, constant: 10),
            self.lowTempIconView.widthAnchor.constraint(equalToConstant: 12),

            self.lowTempLabel.topAnchor.constraint(equalTo: self.highTempIconView.topAnchor, constant: -4),
            self.lowTempLabel.leadingAnchor.constraint(equalTo: self.lowTempIconView.trailingAnchor, constant: 6),

            self.currentTempLabel.topAnchor.constraint(equalTo: self.lowTempLabel.bottomAnchor),
            self.currentTempLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            ])
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
