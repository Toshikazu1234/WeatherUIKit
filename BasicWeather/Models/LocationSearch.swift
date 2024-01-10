//
//  LocationSearch.swift
//  BasicWeather
//
//  Created by R K on 1/3/24.
//

import Foundation

struct LocationSearch: Codable, Equatable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    init(name: String, lat: Double, lon: Double, country: String, state: String) {
        self.name = name
        self.lat = round(lat * 100) / 100
        self.lon = round(lon * 100) / 100
        self.country = country
        self.state = state
    }
    
    static func == (lhs: LocationSearch, rhs: LocationSearch) -> Bool {
        return (lhs.name == rhs.name && lhs.country == rhs.country && lhs.state == rhs.state) || (lhs.lat == rhs.lat && lhs.lon == rhs.lon)
    }
}
