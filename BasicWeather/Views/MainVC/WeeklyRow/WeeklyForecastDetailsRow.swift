//
//  WeeklyForecastDetailsRow.swift
//  BasicWeather
//
//  Created by R K on 1/3/24.
//

import UIKit

final class WeeklyForecastDetailsRow: UITableViewCell {
    static let id = "WeeklyForecastDetailsRow"
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var img: UIImageView!
    @IBOutlet private weak var tempLow: UILabel!
    @IBOutlet private weak var tempHigh: UILabel!
    @IBOutlet private weak var tempSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ forecast: DailyForecast) {
        let low = Int(forecast.lows.average)
        let high = Int(forecast.highs.average)
        let lowF = Float(low)
        let highF = Float(high)
        
        dayLabel.text = forecast.day
        tempLow.text = "\(low)°"
        tempHigh.text = "\(high)°"
        
        if let description = forecast.description {
            let weather = WeatherType(description)
            img.image = weather.icon
            img.tintColor = weather.tint
        } else {
            img.image = nil
        }
        tempSlider.minimumValue = lowF
        tempSlider.maximumValue = highF
        let avg = Int(forecast.tempAvg)
        tempSlider.value = Float(avg)
    }
}
