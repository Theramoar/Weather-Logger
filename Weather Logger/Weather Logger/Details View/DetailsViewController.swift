//
//  DetailsViewController.swift
//  Weather Logger
//
//  Created by Mihails Kuznecovs on 18/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import UIKit


class DetailsViewController: UIViewController {
    var viewModel: DetailsViewModel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var savedAtLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var changeDateButton: UIBarButtonItem?
    var isViewEdited: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        setLabels()
        
        //Add Right Bar Button Items
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change Date", style: .plain, target: self, action: #selector(changeButtonPressed))
        changeDateButton = navigationItem.rightBarButtonItem
        
        //Add Tap Gesture that removes DatePicker from View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        // for tests
        view.accessibilityIdentifier = "detailsView"
        dateLabel.accessibilityIdentifier = "dateLabel"
        dateTextField.accessibilityIdentifier = "dateTextField"
    }
    
    //MARK:- UI Setup Methods
    private func setDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChangedValue), for: .valueChanged)
        return datePicker
    }
    
    private func setLabels() {
        dateLabel.text = "Weather on \(viewModel.dateString)"
        dateTextField.inputView = setDatePicker()
        dateTextField.isHidden = true
        tempLabel.text = viewModel.tempString
        imageView.image = viewModel.weatherImage
        sunriseLabel.text = viewModel.sunriseString
        sunsetLabel.text = viewModel.sunsetString
        savedAtLabel.text = viewModel.savedAtString
        descriptionLabel.text = viewModel.descriptionString
    }
    
    
    //MARK:- User Interaction Methods
    @objc private func viewTapped(sender: UITapGestureRecognizer) {
         self.view.endEditing(true)
    }
    
    @objc private func datePickerChangedValue(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        viewModel.newSelectedDate = datePicker.date
    }
    
    @objc private func changeButtonPressed() {
        if isViewEdited {
            viewModel.saveNewDate()
            dateTextField.endEditing(true)
        }
        isViewEdited = !isViewEdited
        dateLabel.text =  isViewEdited ? "Weather on" : "Weather on \(viewModel.dateString)"
        dateTextField.isHidden = !isViewEdited
        dateTextField.text = viewModel.dateString
        changeDateButton?.title = isViewEdited ? "Done" : "Change Date"
        savedAtLabel.text = viewModel.savedAtString
    }
}

class DetailsViewModel: DetailViewModelType {
    private let savedData: SavedWeatherData
    
    var newSelectedDate: Date?
    
    var dateString: String {
        savedData.getDateString()
    }
    
    var savedAtString: String {
        "Saved at \(savedData.getTimeString(savedData.weatherData.date!))"
    }
    
    var tempString: String {
        "Temperature: \(String(savedData.weatherData.temp)) °C"
    }
    
    var weatherImage: UIImage? {
        UIImage(named: savedData.weatherImageName)
    }
    
    var sunriseString: String {
        "Sunrise at \(savedData.getTimeString(savedData.weatherData.sunrise!))"
    }
    
    var sunsetString: String {
        "Sunset at \(savedData.getTimeString(savedData.weatherData.sunset!))"
    }
    var descriptionString: String {
        savedData.weatherData.weatherDescription ?? "No weather data"
    }
    
    func saveNewDate() {
        guard let date = newSelectedDate else { return }
        CoreDataManager.editDataWithNewDate(weatherData: savedData.weatherData, newDate: date)
    }
    
    init(savedData: SavedWeatherData) {
        self.savedData = savedData
    }
}
