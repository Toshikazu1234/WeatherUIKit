//
//  Api.swift
//  BasicWeather
//
//  Created by R K on 1/3/24.
//

import Foundation

final class Api {
    static let shared = Api()
    private init() {}
    
    private let appid = "fa9f43eb399080f97194832c4c6330a4"
    enum Endpoint: String {
        case currrentWeather = "/data/2.5/weather"
        case weeklyForecast = "/data/2.5/forecast"
        case citySearch = "/geo/1.0/direct"
    }
    
    // MARK: - Sample Resources
    func fetchSample<T: Decodable>(_ type: T.Type, completion: @escaping (T?) -> Void) {
        guard let path = Bundle.main.path(forResource: getResourceName(type), ofType: "json") else {
            completion(nil)
            return
        }
        let url = URL(filePath: path)
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try decoder.decode(
                type,
                from: data)
            completion(decodedData)
        } catch {
            print(error)
            completion(nil)
        }
    }
    
    private func getResourceName<T>(_ type: T.Type) -> String {
        return switch type {
        case is CurrentWeather.Type:
            "CurrentWeather"
        case is WeeklyForecast.Type:
            "WeeklyForecast"
        case is LocationSearch.Type:
            "LocationSearch"
        default:
            ""
        }
    }
    
    // MARK: - Live Data
    private func constructURL(for endpoint: Endpoint, _ lat: Double? = nil, _ lon: Double? = nil, _ city: String? = nil) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = endpoint.rawValue
        switch endpoint {
        case .currrentWeather, .weeklyForecast:
            guard let lat, let lon else { return nil }
            components.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "units", value: "imperial"),
                URLQueryItem(name: "appid", value: appid)
            ]
        case .citySearch:
            guard let city else { return nil }
            components.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "limit", value: "\(10)"),
                URLQueryItem(name: "appid", value: appid)
            ]
        }
        guard let url = components.url else { return nil }
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10)
        request.httpMethod = "GET"
        return request
    }
    
    private func fetch<T: Decodable>(_ type: T.Type, _ request: URLRequest, completion: @escaping(T?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data else {
                completion(nil)
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(
                    type,
                    from: data)
                completion(decodedData)
            } catch {
                print("Current Weather error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchWeather(_ lat: Double, _ lon: Double, completion: @escaping((CurrentWeather?, WeeklyForecast?)) -> Void) {
        var weather: CurrentWeather?
        var forecast: WeeklyForecast?
        
        guard let currentWeather = constructURL(for: .currrentWeather, lat, lon), let weeklyForecast = constructURL(for: .weeklyForecast, lat, lon) else {
            completion((nil, nil))
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        fetch(CurrentWeather.self, currentWeather) { result in
            weather = result
            group.leave()
        }
        
        group.enter()
        fetch(WeeklyForecast.self,weeklyForecast) { result in
            forecast = result
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion((weather, forecast))
        }
    }
    
    func search(_ city: String, completion: @escaping ([LocationSearch]?) -> Void) {
        guard let request = constructURL(for: .citySearch, nil, nil, city) else {
            completion(nil)
            return
        }
        fetch([LocationSearch].self, request) { result in
            completion(result)
        }
    }
}
