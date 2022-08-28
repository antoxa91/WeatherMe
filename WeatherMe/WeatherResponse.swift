//
//  WeatherResponse.swift
//  WeatherMe
//
//  Created by Антон Стафеев on 18.08.2022.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]
    
    enum CodingKeys: String, CodingKey {
        case lat, lon , timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily 
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt, temp, sunrise, sunset
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi
        case clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: Main
    let weatherDescription: Description
    let icon: String
    var weatherIconURL2x: URL {
        let iconAddress = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        return URL(string: iconAddress)!
    }
    var weatherIconURL4x: URL {
        let iconAddress = "https://openweathermap.org/img/wn/\(icon)@4x.png"
        return URL(string: iconAddress)!
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum Description: String, Codable {
    case небольшаяОблачность = "небольшая облачность"
    case небольшойДождь = "небольшой дождь"
    case облачноСПрояснениями = "облачно с прояснениями"
    case пасмурно = "пасмурно"
    case переменнаяОблачность = "переменная облачность"
    case ясно = "ясно"
    case дождь = "дождь"
    case небольшойПроливнойДождь = "небольшой проливной дождь"
    case сильныйДождь = "сильный дождь"
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let clouds: Int
    let pop, uvi: Double 
    let rain: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, rain
        case pop, uvi
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

