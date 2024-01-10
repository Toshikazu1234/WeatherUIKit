//
//  WeeklyForecast.swift
//  BasicWeather
//
//  Created by R K on 1/3/24.
//

import Foundation

struct WeeklyForecast: Decodable {
    let cod: String
    let message: Int
    let cnt: Int // list.count
    let list: [WeeklyForecastList]?
    let city: WeeklyForecastCity?
}

struct WeeklyForecastList: Decodable {
    let dt: Int?
    let main: WeeklyForecastListMain?
    let weather: [WeeklyForecastListWeather]?
    let clouds: WeeklyForecastListClouds?
    let wind: WeeklyForecastListWind?
    let visibility: Int?
    let pop: Double?
    let dt_txt: String?
}

struct WeeklyForecastListMain: Decodable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let seaLevel: Int?
    let groundLevel: Int?
    let humidity: Int?
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

struct WeeklyForecastListWeather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct WeeklyForecastListClouds: Decodable {
    let all: Int?
}

struct WeeklyForecastListWind: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct WeeklyForecastCity: Decodable {
    let id: Int?
    let name: String?
    let coord: Coordinates?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}
