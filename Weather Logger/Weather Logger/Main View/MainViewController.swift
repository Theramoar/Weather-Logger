//
//  ViewController.swift
//  Weather Logger
//
//  Created by Mihails Kuznecovs on 18/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var noDataStackView: UIStackView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLowerView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(NotificationNames.dataReceived), object: nil)
        
        // for tests
        view.accessibilityIdentifier = "mainView"
    }
    
    private func setupLowerView() {
        saveButton.layer.cornerRadius = 10
        infoView.layer.shadowOffset = CGSize(width: 0, height: -3)
        infoView.layer.shadowOpacity = 0.05
        infoView.layer.shadowRadius = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func reload() {
        guard let temperature = UserData.shared.currentWeatherData?.main.temp else { return }
        self.currentTemperatureLabel.text = "Current temperature: \(String(temperature)) °C"
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        viewModel.saveCurrentWeather { saved in
            if saved {
                let checkmark = CheckmarkView(frame: self.view.frame, message: "Saved!")
                self.view.addSubview(checkmark)
                checkmark.animate()
                self.tableView.reloadData()
            }
            else {
                let alert = UIAlertController(title: "Something went wrong", message: "Check your Internet connection", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}



extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = viewModel.tableIsEmpty
        noDataStackView.isHidden = !viewModel.tableIsEmpty
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath) as? WeatherCellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteSavedData(at: indexPath) {
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.viewModel = viewModel.viewModelForSelectedRow(at: indexPath) as? DetailsViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}

