//
//  Extensions.swift
//  BasicWeather
//
//  Created by R K on 1/3/24.
//

import UIKit

extension [WeeklyForecastList] {
    /// Daily averages are calculated from a 5 day forecast every 3 hours
    /// - Returns: [DailyForecast] with max count of 5
    func getDailyAverage() -> [DailyForecast] {
        var dailyAverages: [DailyForecast] = []
        for i in 0..<self.count {
            let item = self[i]
            guard let day = item.dt?.toDay(), let low = item.main?.tempMin, let high = item.main?.tempMax else { continue }
            
            guard dailyAverages.count > 0 else {
                dailyAverages.append(parse(using: item))
                continue
            }
            if dailyAverages.last?.day == day {
                let i = dailyAverages.count - 1
                dailyAverages[i].lows.append(low)
                dailyAverages[i].highs.append(high)
            } else {
                dailyAverages.append(parse(using: item))
            }
        }
        return dailyAverages
    }
    
    /// Used as helper function in `getDailyAverage()`
    /// - Parameter item: Properties were already safe unwrapped so they can be force unwrapped in this function.
    /// - Returns: `DailyForecast` to be used for `WeeklyForecastDetailsRow`
    private func parse(using item: WeeklyForecastList) -> DailyForecast {
        var forecast = DailyForecast(
            day: item.dt!.toDay(),
            description: item.weather!.first?.main)
        forecast.lows.append(item.main!.tempMin!)
        forecast.highs.append(item.main!.tempMax!)
        return forecast
    }
}

extension [Double] {
    var average: Double {
        let count = Double(count)
        return reduce(0, { $0 + $1 }) / count
    }
}

extension Int {
    func toDay() -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        return date.formatted(Date.FormatStyle().weekday(.abbreviated))
    }
    
    func toHour() -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("h:mm")
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let date = Date(timeIntervalSince1970: Double(self))
        return formatter.string(from: date)
    }
}

extension UIViewController {
    func pushVC(_ vc: UIViewController, _ animated: Bool = true) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setBackgroundColor(_ weather: CurrentWeather?) {
        guard let description = weather?.weather.first?.main else {
            resetBackgroundColor()
            return
        }
        let weather = WeatherType(description)
        view.backgroundColor = weather.background
        navigationController?.navigationBar.barTintColor = weather.background
        tabBarController?.tabBar.barTintColor = weather.background
        tabBarController?.tabBar.tintColor = weather.tint
    }
    
    func resetBackgroundColor() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.barTintColor = .white
        tabBarController?.tabBar.tintColor = .systemBlue
    }
}

extension UIStoryboard {
    func instantiate(with id: String) -> UIViewController {
        return instantiateViewController(withIdentifier: id)
    }
}

extension Data {
    var jsonString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted]),
              let prettyJSON = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        return String(prettyJSON)
    }
}

extension UIColor {
    static let cloudColor = UIColor(named: "CloudyBackground")!
    static let rainColor = UIColor(named: "RainyBackground")!
    static let snowColor = UIColor(named: "SnowyBackground")!
    static let sunColor = UIColor(named: "SunnyBackground")!
    static let windColor = UIColor(named: "WindyBackground")!
}
