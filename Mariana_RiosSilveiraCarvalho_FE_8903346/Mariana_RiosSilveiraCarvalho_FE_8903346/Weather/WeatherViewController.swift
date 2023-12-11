//
//  WeatherViewController.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    // MARK: - Private Variables
    private let viewModel: WeatherViewModelProtocol

    // MARK: - Initializer
    required init?(coder: NSCoder) {
        self.viewModel = WeatherViewModel()
        super.init(coder: coder)
    }

    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.retrieveNewSearch { newSearchData in
            if let data = newSearchData {
                self.icon.image = UIImage()
                self.activityIndicator.startAnimating()
                self.viewModel.didUpdateLocation(data)
            } else {
                self.createNewSearchAlert { _ in
                    self.navigationController?.tabBarController?.selectedIndex = 0
                }
            }
        }
    }

    // MARK: - Private Functions
    private func setup() {
        self.setupViewModel()
        self.setupUIComponents()
    }

    private func setupViewModel() {
        self.viewModel.delegate = self
    }

    private func setupUIComponents() {
        self.cityLabel.text = ""
        self.weatherLabel.text = ""
        self.humidityLabel.text = ""
        self.windSpeedLabel.text = ""
        self.temperatureLabel.text = ""
    }

    private func createNewSearchAlert(cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Where would you like to go?", message: "Enter your destination", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].placeholder = "Destination"

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler))

        alert.addAction(UIAlertAction(title: "Go", style: .default, handler: { [unowned alert] _ in
            guard let text = alert.textFields![0].text, text != "" else {
                self.showErrorAlert()
                return
            }

            self.icon.image = UIImage()
            self.activityIndicator.startAnimating()

            let newSearchData = SearchData(city: text, source: "Weather", type: "Weather")
            self.create(searchData: newSearchData) { response in
                if response {
                    self.viewModel.didUpdateLocation(newSearchData)
                } else {
                    self.showErrorAlert("Error", "Something wrong. Please try again.")
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions Functions
    @IBAction func didTapChangeCity(_ sender: Any) {
        self.createNewSearchAlert()
    }
}

// MARK: - WeatherViewModel Delegate
extension WeatherViewController: WeatherViewModelDelegate {
    func showError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Something wrong",
                message: "We could not find any data about this location. Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true, completion: nil)

            self.setupUIComponents()
            self.icon.image = UIImage(systemName: "x.square")
            self.temperatureLabel.text = "Please try again."
            self.activityIndicator.stopAnimating()
        }
    }

    func updateView(city: String, description: String, icon: URL, temperature: String, humidity: String, windSpeed: String) {
        self.icon.load(from: icon) {
            self.activityIndicator.stopAnimating()
        }

        DispatchQueue.main.async {
            self.cityLabel.text = city
            self.weatherLabel.text = description
            self.humidityLabel.text = humidity
            self.windSpeedLabel.text = windSpeed
            self.temperatureLabel.text = temperature
        }

    }

    func updateCoreData(with searchData: SearchData, and weather: WeatherData) {
        self.create(searchHistory: SearchHistoryData(search: searchData, weather: weather)) { response in
            print(response)
        }
    }
}
