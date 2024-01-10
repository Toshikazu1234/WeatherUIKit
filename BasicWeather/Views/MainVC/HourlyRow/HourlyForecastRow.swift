//
//  HourlyForecastRow.swift
//  BasicWeather
//
//  Created by R K on 1/2/24.
//

import UIKit

final class HourlyForecastRow: UITableViewCell {
    static let id = "HourlyForecastRow"
    private var forecast: [WeeklyForecastList] = []
    
    @IBOutlet private weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ forecast: [WeeklyForecastList]) {
        self.forecast = forecast
        collectionView.reloadData()
    }
}

extension HourlyForecastRow: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count > 8 ? 8 : forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyForecastItem.id,
            for: indexPath) as! HourlyForecastItem
        cell.configure(forecast[indexPath.row])
        return cell
    }
}

extension HourlyForecastRow: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 128)
    }
}
