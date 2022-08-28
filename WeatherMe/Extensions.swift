//
//  Extensions.swift
//  WeatherMe
//
//  Created by Антон Стафеев on 18.08.2022.
//

import UIKit
import CoreLocation

extension UIImageView {
    func loadFrom(URLAddress: String) {
        let imageCache = NSCache<AnyObject,AnyObject>()
        
        if let image = imageCache.object(forKey: URLAddress as NSString) as? UIImage {
            self.image = image
            return
        }
        
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        imageCache.setObject(imageCache, forKey: URLAddress as NSString)///
                        self?.image = loadedImage
                    }
                }
            }
        }
    }
}

// MARK: - получить день недели или час из даты
extension Date {
    func getDayOfWeek(dayForCell: Date?) -> String? {
        guard let inputDate = dayForCell else { return "" }
        let dateFormatter  = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: inputDate).localizedCapitalized
    }
    
    func getHourOfDay(hourForCell: Date?) -> String? {
        guard let inputDate = hourForCell else { return "" }
        let dateFormatter  = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: inputDate).localizedCapitalized
    }
}


// MARK: - Текущее местоположение чтобы получить
extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

// MARK: - Первая буква в строке большая
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// MARK: - Gradient
extension UIView {
    func createGradient(color1: CGColor, color2: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [color1, color2]
        gradientLayer.cornerRadius = 30
        self.layer.insertSublayer(gradientLayer, at: 1)
    }
}
