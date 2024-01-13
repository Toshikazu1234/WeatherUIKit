//
//  HourlyForecastItem.swift
//  BasicWeather
//
//  Created by R K on 1/3/24.
//

import UIKit

final class HourlyForecastItem: UICollectionViewCell {
    static let id = "HourlyForecastItem"
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var img: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    
    func configure(_ forecast: WeeklyForecastList) {
        timeLabel.text = forecast.dt?.toHour()
        if let description = forecast.weather?.first?.main {
            let weather = WeatherType(description)
            img.image = weather.icon
            img.tintColor = weather.tint
        } else {
            img.image = nil
        }
        if let temp = forecast.main?.temp {
            tempLabel.text = "\(Int(temp))°"
        } else {
            tempLabel.text = nil
        }
    }
}
