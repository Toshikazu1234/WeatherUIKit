//
//  WeeklyForecastRow.swift
//  BasicWeather
//
//  Created by R K on 1/2/24.
//

import UIKit

final class WeeklyForecastRow: UITableViewCell {
    static let id = "WeeklyForecastRow"
    private var forecast: [DailyForecast] = []
    
    @IBOutlet private weak var tableView: UITableView!

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ forecast: [DailyForecast]) {
        self.forecast = forecast
        tableView.reloadData()
    }
}

extension WeeklyForecastRow: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count > 5 ? 5 : forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeeklyForecastDetailsRow.id,
            for: indexPath) as! WeeklyForecastDetailsRow
        cell.configure(forecast[indexPath.row])
        return cell
    }
}

extension WeeklyForecastRow: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
