//
//  WeatherCollectionViewCell.swift
//  WeatherMe
//
//  Created by Антон Стафеев on 18.08.2022.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var hourLabel: UILabel!

    func configure(with model: Current) { 
        self.tempLabel.text = "\(Int(model.temp))°"
        self.hourLabel.text = Date().getHourOfDay(hourForCell: Date(timeIntervalSince1970: Double(model.dt)))
        
        self.iconImageView.contentMode = .scaleAspectFit
        guard let iconAddress = model.weather.first?.weatherIconURL2x.absoluteString else {return}
        self.iconImageView.loadFrom(URLAddress: iconAddress)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
