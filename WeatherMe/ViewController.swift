//
//  ViewController.swift
//  WeatherMe
//
//  Created by Антон Стафеев on 18.08.2022.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    var headerView: UIView!
    var searchButton: UIBarButtonItem!

    var models = [Daily]()
    var hourlyModels = [Current]()
        
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currentWeather: Current?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
                table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = UIColor(named: "Primary")!
        view.backgroundColor = UIColor(named: "Primary")!
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.circle"), style: .plain, target: self, action: #selector(currentLocationTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), menu: menuTapped())
        
        fetchWeatherFull()
    }
    
    func menuTapped() -> UIMenu {
        let searchPlace = UIAction(
            title: "Поиск",
            image: UIImage(systemName: "magnifyingglass.circle")) { [weak self] _ in
                let ac = UIAlertController(title: "Введите местоположение", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Отмена", style: .cancel))
                ac.addTextField()
                
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    guard let field = ac.textFields else { return }
                    guard let city = field[0].text, !city.isEmpty else {
                        return
                    }
                    self?.fetchWeather(cityName: city)
                }))
                self?.present(ac, animated: true)
            }
        
        let menu = UIMenu(title: "Меню", image: nil, children: [searchPlace])
        return menu
    }

        
    @objc func currentLocationTapped(_ sender: UIBarButtonItem) {
        fetchWeatherFull()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
}


// MARK: - Location
extension ViewController: CLLocationManagerDelegate {
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.startUpdatingLocation()
            
            fetchWeatherFull()
        }
    }
    
    func currentPlacemark(currentPlacemark: CLLocation) {
        currentPlacemark.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            
            self.title = placemark.locality!
        }
    }
    
    
    func fetchWeatherFull() {
        guard let currentLocation = currentLocation else { return}
        fetchWeather(withLocation: currentLocation)
    }
    
    func fetchWeather(withLocation currentLocation: CLLocation) {
        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?&appid=\(apiKey)&units=metric&lang=ru&lat=\(lat)&lon=\(lon)"
                
        URLSession.shared.dataTask(with: URL(string: weatherURL)!) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch {
                print(error)
            }
                      
            self.appendData(json: json)
            self.currentPlacemark(currentPlacemark: currentLocation)
            
        }.resume()
    }
    
    
    func appendData(json: WeatherResponse?) {
        guard let result = json else {return}
        
        self.models = result.daily
        self.currentWeather = result.current
        self.hourlyModels = result.hourly
        
        DispatchQueue.main.async {
            self.table.reloadData()
            self.table.tableHeaderView = self.createTableHeader()
        }
    }
    
    
    func fetchWeather(cityName: String) {
        CLGeocoder().geocodeAddressString(cityName) { placemark, error in
            guard let location = placemark?.first?.location,
                  error == nil else {
                return
            }
            self.fetchWeather(withLocation: location)
        }
    }
}

 

// MARK: - Table View
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor.systemMint.withAlphaComponent(0.1)
            cell.layer.cornerRadius = cell.frame.size.height/10
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor(named: "Primary")!
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Почасовой прогноз"
        }
        return "Прогноз на неделю"
    }
}


