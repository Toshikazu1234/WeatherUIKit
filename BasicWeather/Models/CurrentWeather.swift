//
//  CurrentWeather.swift
//  BasicWeather
//
//  Created by R K on 1/3/24.
//

import UIKit

struct CurrentWeather: Codable {
    let coord: Coordinates
    let weather: [CurrentWeatherWeather]
    let base: String
    let main: CurrentWeatherMain?
    let visibility: Int?
    let wind: CurrentWeatherWind?
    let dt: Int?
    let sys: CurrentWeatherSys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}

struct CurrentWeatherWeather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct CurrentWeatherMain: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Double?
    let humidity: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct CurrentWeatherWind: Codable {
    let speed: Double?
    let deg: Double?
    let gust: Double?
}

struct CurrentWeatherSys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
