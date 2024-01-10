//
//  DailyForecast.swift
//  BasicWeather
//
//  Created by R K on 1/3/24.
//

import Foundation

struct DailyForecast {
    let day: String
    let description: String?
    var tempAvg: Double {
        return (lows.average + highs.average) / 2
    }
    var lows: [Double] = []
    var highs: [Double] = []
}
