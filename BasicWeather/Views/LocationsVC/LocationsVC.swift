//
//  LocationsVC.swift
//  BasicWeather
//
//  Created by R K on 1/4/24.
//

import UIKit

protocol LocationsVCDelegate: AnyObject {
    func didSelect(_ location: LocationSearch)
}

final class LocationsVC: UIViewController {
    static let id = "LocationsVC"
    weak var delegate: LocationsVCDelegate?
    
    private let lm = LocationManager.shared
    
    private var searchTimer = Timer()
    
    private lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultsVC())
        search.searchBar.placeholder = "Search by city"
        search.obscuresBackgroundDuringPresentation = true
        search.hidesNavigationBarDuringPresentation = false
        search.searchResultsUpdater = self
        return search
    }()
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension LocationsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty, let searchResults = searchController.searchResultsController as? SearchResultsVC else {
            return
        }
        searchResults.delegate = self
        searchTimer.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            guard let self else { return }
            searchTimer.invalidate()
            searchResults.update(search: text)
        }
    }
}

extension LocationsVC: SearchResultsVCDelegate {
    func didSelect(_ item: LocationSearch) {
        lm.appendAndSave(item)
        let locations = lm.getLocations()
        let index = IndexPath(
            row: locations.count - 1,
            section: 0)
        tableView.beginUpdates()
        tableView.insertRows(
            at: [index],
            with: .automatic)
        tableView.endUpdates()
        search.isActive = false
    }
}

extension LocationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let locations = lm.getLocations()
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationRow.id,
            for: indexPath) as! LocationRow
        let locations = lm.getLocations()
        cell.configure(locations[indexPath.row])
        return cell
    }
}

extension LocationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let locations = lm.getLocations()
        let i = indexPath.row
        
        lm.saveSelected(locations[i])
        delegate?.didSelect(locations[i])
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locations = lm.getLocations()
            lm.delete(locations[indexPath.row])
            tableView.beginUpdates()
            tableView.deleteRows(
                at: [indexPath],
                with: .automatic)
            tableView.endUpdates()
        }
    }
}
