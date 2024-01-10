//
//  LocationRow.swift
//  BasicWeather
//
//  Created by R K on 1/4/24.
//

import UIKit

final class LocationRow: UITableViewCell {
    static let id = "LocationRow"
    
    @IBOutlet private weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ location: LocationSearch) {
        locationLabel.text = location.name
    }
}
