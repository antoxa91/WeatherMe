//
//  WeatherTableViewCell.swift
//  WeatherMe
//
//  Created by Антон Стафеев on 18.08.2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var popLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell",
                     bundle: nil)
    }
    
    func configure(with model: Daily) {
        self.tempLabel.text = "\(Int(model.temp.min))°/\(Int(model.temp.max))°"
        self.popLabel.text = String(format: "%.f", model.pop * 100) + "%"
        
        self.dayLabel.text = Date().getDayOfWeek(dayForCell: Date(timeIntervalSince1970: Double(model.dt)))
        
        self.iconImageView.contentMode = .scaleAspectFit
        guard let iconAddress = model.weather.first?.weatherIconURL2x.absoluteString else {return}
        self.iconImageView.loadFrom(URLAddress: iconAddress)
    }
}
