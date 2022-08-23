//
//  HeaderView.swift
//  WeatherMe
//
//  Created by Антон Стафеев on 19.08.2022.
//

import UIKit
import CoreLocation

extension ViewController {
    
    func createTableHeader() -> UIView {
        let width = view.frame.size.width
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width/1.4))
        headerView.createGradient(color1: CGColor(red: 0, green: 215, blue: 255, alpha: 1),
                                  color2: UIColor(named: "ViewColor")!)
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.headerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.headerView.transform = .identity
        }, completion: nil)
        
        
        let dateLabel = UILabel(frame: CGRect(
            x: 10,
            y: 10,
            width: width-20,
            height: width / 6))
        
        let summaryLabel = UILabel(frame: CGRect(
            x: 10,
            y: dateLabel.frame.size.height/2,
            width: width-20,
            height: width / 4))
        
        let iconImage = UIImageView(frame: CGRect(
            x: width/2,
            y: summaryLabel.frame.size.height/3+dateLabel.frame.size.height/2,
            width: width / 1.8,
            height: width / 2))
        
        let tempLabel = UILabel(frame: CGRect(
            x: 20,
            y: summaryLabel.frame.size.height/3+dateLabel.frame.size.height/2,
            width: width-10,
            height: width/2))
        
        let feelsTempLabel = UILabel(frame: CGRect(
            x: 10,
            y: 10+tempLabel.frame.size.height/2+summaryLabel.frame.size.height/2,
            width: width-10,
            height: width/4))
        
        let pressureLabel = UILabel(frame: CGRect(
            x: 10,
            y: iconImage.frame.size.height/2 + tempLabel.frame.size.height/2,
            width: width/2,
            height: width/3))
        
        let windLabel = UILabel(frame: CGRect(
            x: width/2.1,
            y: iconImage.frame.size.height/2 + tempLabel.frame.size.height/2,
            width: width/3,
            height: width/3))

        let humidityLabel = UILabel(frame: CGRect(
            x: width/1.25,
            y: iconImage.frame.size.height/2 + tempLabel.frame.size.height/2,
            width: width/3,
            height: width/3))
        
        headerView.addSubview(dateLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(iconImage)
        headerView.addSubview(tempLabel)
        headerView.addSubview(feelsTempLabel)
        headerView.addSubview(pressureLabel)
        headerView.addSubview(windLabel)
        headerView.addSubview(humidityLabel)
        
        
        dateLabel.text = Date().formatted(date: .numeric, time: .shortened)
        
        guard let currentWeather = currentWeather else { return UIView()}
        
        summaryLabel.font = UIFont(name: "Helvetica", size: 28)
        summaryLabel.textAlignment = .center
        summaryLabel.adjustsFontSizeToFitWidth = true
        summaryLabel.text = currentWeather.weather.first?.weatherDescription.rawValue.capitalizingFirstLetter()
        
        iconImage.contentMode = .scaleAspectFill
        guard let iconAddress = currentWeather.weather.first?.weatherIconURL4x.absoluteString else {return UIView()}
        iconImage.loadFrom(URLAddress: iconAddress)
        
        tempLabel.text = "\(Int(currentWeather.temp))°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 52)
        
        feelsTempLabel.text = "Ощущается как \(Int(currentWeather.feelsLike))°"
        
        pressureLabel.attributedText = imageAndText(
            image: UIImage(systemName: "barometer")!.withTintColor(UIColor.label),
            param: String(format: " %.f", (Double(currentWeather.pressure) / 1.333))+" мм рт.ст")

        windLabel.attributedText = imageAndText(
            image: UIImage(systemName: "wind")!.withTintColor(UIColor.label),
            param: " \(currentWeather.windSpeed) м/c")
        
        humidityLabel.attributedText = imageAndText(
            image: (UIImage(systemName: "drop")!.withTintColor(UIColor.label)),
            param: " \(currentWeather.humidity) %")

        return headerView
    }
    
    
    func imageAndText(image: UIImage, param: String) -> NSAttributedString {
        let fullString = NSMutableAttributedString()
        let imageAttachment = NSTextAttachment()
        
        imageAttachment.image = image
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: param))
        
        return fullString
    }
}

