//
//  WeatherCell.swift
//  Weather Logger
//
//  Created by Mihails Kuznecovs on 18/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var viewModel: WeatherCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            self.temperatureLabel.text = viewModel.tempString
            self.dateLabel.text = viewModel.dateString
            self.selectionStyle = .none
        }
    }
}

class WeatherCellViewModel: CellViewModelType {
    private var savedData: SavedWeatherData
    
    var dateString: String {
        "Date: \(savedData.getDateString())"
    }
    
    var tempString: String {
        "Temperature: \(savedData.weatherData.temp) °C"
    }
    
    init(savedData: SavedWeatherData) {
        self.savedData = savedData
    }
}
