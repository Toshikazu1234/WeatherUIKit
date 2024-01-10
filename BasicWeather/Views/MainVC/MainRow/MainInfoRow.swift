//
//  MainInfoRow.swift
//  BasicWeather
//
//  Created by R K on 1/2/24.
//

import UIKit

final class MainInfoRow: UITableViewCell {
    static let id = "MainInfoRow"
    
    @IBOutlet private weak var img: UIImageView!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var tempRangeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ weather: CurrentWeather?) {
        guard let weather else {
            locationLabel.text = "N/A"
            tempLabel.text = "N/A"
            weatherLabel.text = "N/A"
            tempRangeLabel.text = "N/A"
            img.image = nil
            return
        }
        locationLabel.text = weather.name
        weatherLabel.text = weather.weather.first?.main
        if let main = weather.main {
            if let temp = main.temp {
                tempLabel.text = "\(Int(temp))"
            } else {
                tempLabel.text = "N/A"
            }
            if let max = main.tempMax, let min = main.tempMin {
                tempRangeLabel.text = "H:\(Int(max))°  L:\(Int(min))°"
            } else {
                tempRangeLabel.text = nil
            }
        } else {
            tempLabel.text = "N/A"
        }
        if let description = weather.weather.first?.main {
            let weather = WeatherType(description)
            img.image = weather.icon
            img.tintColor = weather.tint
        } else {
            img.image = nil
        }
    }
}
