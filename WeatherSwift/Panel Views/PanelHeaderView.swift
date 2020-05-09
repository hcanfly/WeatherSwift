//
//  PanelHeaderView.swift
//  WeatherSwift
//
//  Created by Gary Hanson on 5/2/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit

// used by all panels
let panelFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue-Light", size: 16)!)


final class PanelHeaderView : UIView {
    private let panelTitle = UILabel()
    private let separator = UIView()


    convenience init(title: String) {
        self.init(frame: CGRect.zero)

        self.panelTitle.text = title
        self.panelTitle.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "HelveticaNeue", size: 20)!)
        self.panelTitle.textColor = .white
        self.panelTitle.sizeToFit()
        self.panelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.panelTitle)
        
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.backgroundColor = .white
        self.addSubview(self.separator)

        self.setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.panelTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.panelTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.panelTitle.heightAnchor.constraint(equalToConstant: 32),

            self.separator.topAnchor.constraint(equalTo: self.panelTitle.bottomAnchor, constant: 0),
            self.separator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.separator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            self.separator.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),  //FIXME!!
        ])
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
