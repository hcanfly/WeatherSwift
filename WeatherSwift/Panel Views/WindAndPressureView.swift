//
//  PanelView.swift
//  WeatherSwift
//
//  Created by Gary Hanson on 5/2/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//


import UIKit

final class WindAndPressureView : UIView {
    private let headerView = PanelHeaderView(title: "Wind and Pressure")

    private let bigBladesImageView = UIImageView(image: UIImage(named: "blade_big")!)
    private let smallBladesImageView = UIImageView(image: UIImage(named: "blade_small")!)
    private var bigPoleImageView = UIImageView(frame: CGRect.zero)
    private var smallPoleImageView = UIImageView(frame: CGRect.zero)
    private let windLabel = UILabel()
    private let windInfoLabel = UILabel()
    private let baroLabel = UILabel()
    private let baroInfoLabel = UILabel()
    private var isSpinning = false


    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(patternImage: UIImage(named: "PanelBackground")!)
        self.layer.opacity = 0.8
        self.layer.cornerRadius = 6

        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.headerView)

        self.bigPoleImageView = UIImageView(image: UIImage(named: "bigpole")!)
        self.bigPoleImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bigPoleImageView)
        self.bigBladesImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bigBladesImageView)
        self.smallPoleImageView = UIImageView(image: UIImage(named: "smallpole")!)
        self.smallPoleImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(smallPoleImageView)
        self.smallBladesImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.smallBladesImageView)
        
        self.windLabel.text = "Wind"
        self.windLabel.font = panelFont
        self.windLabel.textColor = .white
        self.windLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.windLabel)
        
        self.windInfoLabel.font = panelFont
        self.windInfoLabel.textColor = .white
        self.windInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.windInfoLabel)
        
        self.baroLabel.text = "Barometer"
        self.baroLabel.font = panelFont
        self.baroLabel.textColor = .white
        self.baroLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.baroLabel)
        
        self.baroInfoLabel.font = panelFont
        self.baroInfoLabel.textAlignment = .center
        self.baroInfoLabel.textColor = .white
        self.baroInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.baroInfoLabel)

        self.setupContraints()
    }

    func reloadData() {
        if self.isSpinning {
            self.smallBladesImageView.layer.removeAllAnimations()
            self.bigBladesImageView.layer.removeAllAnimations()
            self.isSpinning = false
        }
        
        self.windInfoLabel.text = ViewModel.shared.windInfo
        self.baroInfoLabel.text = ViewModel.shared.pressure
        self.rotateBlades()
    }
        
    private func setupContraints() {

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            self.headerView.heightAnchor.constraint(equalToConstant: 40),
            self.headerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -8),

            self.bigPoleImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26),
            self.bigPoleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),

            self.bigBladesImageView.centerYAnchor.constraint(equalTo: self.bigPoleImageView.topAnchor, constant: 0),
            self.bigBladesImageView.centerXAnchor.constraint(equalTo: self.bigPoleImageView.centerXAnchor, constant: 0),

            self.smallPoleImageView.bottomAnchor.constraint(equalTo: self.bigPoleImageView.bottomAnchor, constant: 0),
            self.smallPoleImageView.leadingAnchor.constraint(equalTo: self.bigPoleImageView.leadingAnchor, constant: 60),

            self.smallBladesImageView.centerYAnchor.constraint(equalTo: self.smallPoleImageView.topAnchor, constant: 0),
            self.smallBladesImageView.centerXAnchor.constraint(equalTo: self.smallPoleImageView.centerXAnchor, constant: 0),

            self.windLabel.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 14),
            self.windLabel.leadingAnchor.constraint(equalTo: self.smallPoleImageView.trailingAnchor, constant: 50),
            self.windInfoLabel.topAnchor.constraint(equalTo: self.windLabel.bottomAnchor, constant: 2),
            self.windInfoLabel.leadingAnchor.constraint(equalTo: self.windLabel.leadingAnchor, constant: 0),

            self.baroInfoLabel.bottomAnchor.constraint(equalTo: self.bigPoleImageView.bottomAnchor, constant: 0),
            self.baroLabel.bottomAnchor.constraint(equalTo: self.baroInfoLabel.topAnchor, constant: 0),
            self.baroLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -90),
            self.baroInfoLabel.centerXAnchor.constraint(equalTo: self.baroLabel.centerXAnchor, constant: 0),

        ])
    }

    func runSpinAnimationOn(view: UIView, duration: Double, rotationSpeed: Double) {

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")

        rotationAnimation.toValue = NSNumber(value: Double(.pi * 2.0 * rotationSpeed * duration))
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.infinity

        view.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    private func rotateBlades() {

        let windSpeed = ViewModel.shared.windSpeed

        if windSpeed > 1.0 {

            let rotationSpeed: Double = windSpeed > 18.0 ? 1.5 : (windSpeed > 10.0) ? 1.0 : (windSpeed > 4.0) ? 0.6 : 0.1
            self.runSpinAnimationOn(view: self.smallBladesImageView, duration: 1.0, rotationSpeed: rotationSpeed)
            self.runSpinAnimationOn(view: self.bigBladesImageView, duration: 1.0, rotationSpeed: rotationSpeed)
            self.isSpinning = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
