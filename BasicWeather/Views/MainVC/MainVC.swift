//
//  ViewController.swift
//  BasicWeather
//
//  Created by R K on 1/2/24.
//

import UIKit
import CoreLocation

final class MainVC: UIViewController {
    private let lm = LocationManager.shared
    
    private var currentWeather: CurrentWeather? {
        didSet {
            setBackgroundColor(currentWeather)
        }
    }
    private var weeklyForecast: WeeklyForecast?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noLocationsView: UIView!
    @IBOutlet private weak var suggestionArrow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noLocationsView.isHidden = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        if let location = lm.getSelectedLocation() {
            fetchData(using: location)
        } else {
            pushLocationsVC()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBackgroundColor(currentWeather)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetBackgroundColor()
    }
    
    private func fetchData(using location: LocationSearch) {
        let lat = location.lat
        let lon = location.lon
        Api.shared.fetchWeather(lat, lon) { [unowned self] current, weekly in
            guard let current, let weekly else {
                noLocationsView.isHidden = false
                return
            }
            currentWeather = current
            weeklyForecast = weekly
            tableView.reloadData()
            noLocationsView.isHidden = true
        }
    }
    
    @IBAction private func didTapListButton(_ sender: UIBarButtonItem) {
        pushLocationsVC()
    }
    
    private func pushLocationsVC() {
        let sb = UIStoryboard(
            name: LocationsVC.id,
            bundle: nil)
        let vc = sb.instantiate(with: LocationsVC.id) as! LocationsVC
        vc.delegate = self
        pushVC(vc)
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MainInfoRow.id,
                for: indexPath) as! MainInfoRow
            cell.configure(currentWeather)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HourlyForecastRow.id,
                for: indexPath) as! HourlyForecastRow
            if let list = weeklyForecast?.list {
                cell.configure(list)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WeeklyForecastRow.id,
                for: indexPath) as! WeeklyForecastRow
            if let list = weeklyForecast?.list {
                cell.configure(list.getDailyAverage())
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 250
        case 1:
            return 160
        case 2:
            return 330
        default:
            return 0
        }
    }
}

extension MainVC: LocationsVCDelegate {
    func didSelect(_ location: LocationSearch) {
        fetchData(using: location)
    }
}
