//
//  ViewController.swift
//  WeatherSwift
//
//  Created by Gary on 4/30/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


private extension Selector {
    static let handleBecomeActivate = #selector(ViewController.refreshOnBecomeActive)
    static let handleRefreshButtonTapped = #selector(ViewController.handleRefreshTapped)
}

final class ViewController: UIViewController {
    private var backgroundImageView: UIImageView!
    private var blurredBackgroundImageView: UIImageView!
    private var titleLabel: UILabel!
    private var scrollView: UIScrollView!
    private let backgroundImage = UIImage(named: "MountainView")
    private let blurredBackgroundImage = UIImage(named: "BlurredMountainView")
    private var backgroundIsRain = false

    private var currentConditionsView: CurrentConditionsView!
    private var detailsPanel: DetailsPanelView!
    private var forecastView: ForecastView!
    private var windPressureView: WindAndPressureView!
    private var downloadCount = 0


    override func loadView() {
        super.loadView()

        self.backgroundImageView = UIImageView(frame: self.view.frame)
        self.backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.backgroundImageView.image = self.backgroundImage
        self.view.addSubview(self.backgroundImageView)

        self.blurredBackgroundImageView = UIImageView(frame: self.view.frame)
        self.blurredBackgroundImageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.blurredBackgroundImageView.image = self.blurredBackgroundImage
        self.blurredBackgroundImageView.layer.opacity = 0.0
        self.view.addSubview(self.blurredBackgroundImageView)

        // for next line, also need to set UIViewControllerBasedStatusBarAppearance to false in info.plist
        self.navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationItem.title = "Mountain View"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = false
        // good oolor, but can't see refresh button
        //self.navigationController!.navigationBar.barTintColor = UIColor(hex: 0x678DCE)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: .handleRefreshButtonTapped)

        self.scrollView = UIScrollView(frame: CGRect.zero)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)

        self.currentConditionsView = CurrentConditionsView(frame: CGRect.zero)
        self.currentConditionsView.backgroundColor = .clear
        self.currentConditionsView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.currentConditionsView)

        self.detailsPanel = DetailsPanelView(frame: CGRect.zero)
        self.detailsPanel.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.detailsPanel)

        self.forecastView = ForecastView(frame: CGRect.zero)
        self.forecastView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.forecastView)
        
        self.windPressureView = WindAndPressureView(frame: CGRect.zero)
        self.windPressureView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.windPressureView)

        setupContraints()

        NotificationCenter.default.addObserver(self, selector: .handleBecomeActivate, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func refreshOnBecomeActive() {
        self.getWeather()

    }

    @objc func handleRefreshTapped() {
        guard self.downloadCount == 0 else {
            return
        }

        self.getWeather()
    }


    private func setupContraints() {
        let edgeInsets = self.view.safeAreaInsets

        NSLayoutConstraint.activate([

            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: edgeInsets.left),
            self.scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: edgeInsets.bottom),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: edgeInsets.right),

            self.currentConditionsView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: (self.view.bounds.height - (self.view.bounds.height * 0.297)).rounded()),
            self.currentConditionsView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.currentConditionsView.heightAnchor.constraint(equalToConstant: 160),

            self.detailsPanel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 4),
            self.detailsPanel.topAnchor.constraint(equalTo: self.currentConditionsView.bottomAnchor, constant: 25),
            self.detailsPanel.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -8),
            self.detailsPanel.heightAnchor.constraint(equalToConstant: 165),

            self.forecastView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 4),
            self.forecastView.topAnchor.constraint(equalTo: self.detailsPanel.bottomAnchor, constant: 25),
            self.forecastView.heightAnchor.constraint(equalToConstant: 254),
            self.forecastView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -8),

            self.windPressureView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 4),
            self.windPressureView.topAnchor.constraint(equalTo: self.forecastView.bottomAnchor, constant: 25),
            self.windPressureView.heightAnchor.constraint(equalToConstant: 160),
            self.windPressureView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -8),
            self.windPressureView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
        ])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setBackgroundImage(isRaining: Bool) {
        guard isRaining != self.backgroundIsRain else {
            return
        }

        self.backgroundIsRain = isRaining
        let backgroundImage = self.backgroundIsRain ? UIImage(named: "RainyDay01") : UIImage(named: "BlueSky")
        self.blurredBackgroundImageView.layer.opacity = 0.0
        UIView.transition(with: self.backgroundImageView,
                          duration: 2.0,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.backgroundImageView.image = backgroundImage
        }, completion: nil)

    }

    private func getWeather() {
        self.downloadCount = 0

        self.getCurrentWeather()
        self.getForecastWeather()
    }

    private func getCurrentWeather() {
        NetworkData.getCurrentWeather(myType: [CurrentData].self)  { [weak self] weather in

            if let self = self {
                ViewModel.shared.current = weather[0]

                self.setBackgroundImage(isRaining: ViewModel.shared.isRaining)

                self.downloadCount += 1
                self.refreshViews()

            }
        }
    }

    private func getForecastWeather() {
        NetworkData.getForecastWeather(myType: ForecastData.self)  { [weak self] weather in

            if let self = self {
                ViewModel.shared.forecast = weather

                self.downloadCount += 1
                self.refreshViews()

            }
        }
    }

    private func refreshViews() {

        if self.downloadCount == 2 {        // wait until we have both current and forecast
            self.currentConditionsView.reloadData()
            self.detailsPanel.reloadData()
            self.forecastView.reloadData()
            self.windPressureView.reloadData()
            self.view.setNeedsDisplay()
            self.downloadCount = 0
        }
    }

}

extension ViewController : UIScrollViewDelegate {

    // Using the Accelerate framework and Convolution you can apply a blur during scrolling
    // however, it uses a lot of CPU. Don't want to use up the battery for a simple app.
    // So, this is old method, but it works just fine and is easy on the CPU.
    // Put a blurred image in front of the background image. Set its opacity to 0. Then adjust
    // the opacity while scrolling.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.backgroundIsRain == false else {     // rain background is nice and dark, no need to blur
            return
        }

        let scrollThreshold = self.view.bounds.size.height * 0.6

        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= scrollThreshold {
            let percent = Float(scrollView.contentOffset.y / scrollThreshold)

            self.blurredBackgroundImageView.layer.opacity = percent
        } else if scrollView.contentOffset.y > scrollThreshold {
            self.blurredBackgroundImageView.layer.opacity = 1.0
        } else if scrollView.contentOffset.y <= 0 {
            self.blurredBackgroundImageView.layer.opacity = 0.0
        }
    }

}
