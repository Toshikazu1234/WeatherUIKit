//
//  LocationManager.swift
//  BasicWeather
//
//  Created by R K on 1/4/24.
//

import Foundation

final class LocationManager {
    static let shared = LocationManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    private var selectedLocation: LocationSearch?
    private var locations: [LocationSearch] = []
    
    func getSelectedLocation() -> LocationSearch? {
        if let selectedLocation {
            return selectedLocation
        } else {
            guard let data = defaults.object(forKey: "Selected") as? Data else { return nil }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(
                    LocationSearch.self,
                    from: data)
                selectedLocation = decodedData
                return selectedLocation
            } catch {
                return nil
            }
        }
    }
    
    func getLocations() -> [LocationSearch] {
        if !locations.isEmpty {
            return locations
        } else {
            guard let data = defaults.object(forKey: "Locations") as? [Data] else { return [] }
            do {
                let decoder = JSONDecoder()
                for item in data {
                    let decodedData = try decoder.decode(
                        LocationSearch.self,
                        from: item)
                    locations.append(decodedData)
                }
                return locations
            } catch {
                print(error)
                return []
            }
        }
    }
    
    func appendAndSave(_ location: LocationSearch) {
        locations.append(location)
        saveLocations()
    }
    
    private func saveLocations() {
        do {
            var encoded: [Data] = []
            let encoder = JSONEncoder()
            for location in locations {
                let data = try encoder.encode(location)
                encoded.append(data)
            }
            defaults.set(encoded, forKey: "Locations")
        } catch {
            print(error)
        }
    }
    
    func saveSelected(_ location: LocationSearch) {
        selectedLocation = location
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(location)
            defaults.set(data, forKey: "Selected")
        } catch {
            print(error)
        }
    }
    
    func delete(_ location: LocationSearch) {
        for i in 0..<locations.count {
            guard location == locations[i] else { continue }
            locations.remove(at: i)
            saveLocations()
            return
        }
    }
}
