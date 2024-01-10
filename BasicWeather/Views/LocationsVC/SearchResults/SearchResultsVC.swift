//
//  SearchResultsVC.swift
//  BasicWeather
//
//  Created by R K on 1/4/24.
//

import UIKit

protocol SearchResultsVCDelegate where Self: UIViewController {
    func didSelect(_ item: LocationSearch)
}

final class SearchResultsVC: UIViewController {
    weak var delegate: SearchResultsVCDelegate?
    
    private var searchTerm: String?
    
    private var results: [LocationSearch] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            SearchResultsRow.self,
            forCellReuseIdentifier: SearchResultsRow.id)
    }
    
    func update(search text: String) {
        guard !text.isEmpty else {
            searchTerm = nil
            results = []
            tableView.reloadData()
            return
        }
        Api.shared.search(text) { locations in
            guard let locations, !locations.isEmpty else {
                // TODO: - Display no results UI
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.results = locations
                self?.tableView.reloadData()
            }
        }
    }
}

extension SearchResultsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultsRow.id,
            for: indexPath) as! SearchResultsRow
        cell.configure(results[indexPath.row])
        return cell
    }
}

extension SearchResultsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = results[indexPath.row]
        delegate?.didSelect(item)
    }
}
