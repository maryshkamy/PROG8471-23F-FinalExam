//
//  WeatherViewModel.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import Foundation

protocol WeatherViewModelDelegate: AnyObject {
    func showError()
    func updateView(city: String, description: String, icon: URL, temperature: String, humidity: String, windSpeed: String)
    func updateCoreData(with searchData: SearchData, and weather: WeatherData)
}

protocol WeatherViewModelProtocol: AnyObject {
    var delegate: WeatherViewModelDelegate? { get set }
    func load(_ weatherData: WeatherData)
    func didUpdateLocation(_ newSearchData: SearchData)
}

class WeatherViewModel: WeatherViewModelProtocol {
    // MARK: - Private Variables
    private var weather: Weather?

    // MARK: - Protocol Variables
    weak var delegate: WeatherViewModelDelegate?

    // MARK: - Protocol Functions
    func load(_ weatherData: WeatherData) {
        if let urlIcon = URL(string: weatherData.icon) {
            self.delegate?.updateView(
                city: weatherData.city,
                description: weatherData.description,
                icon: urlIcon,
                temperature: "\(weatherData.temperature.toInt())º",
                humidity: "Humidity: \(weatherData.humidity)%",
                windSpeed: "Wind: \(weatherData.wind.toKmPerHour().toString()) km/h")
        } else {
            self.delegate?.showError()
        }
    }

    func didUpdateLocation(_ newSearchData: SearchData) {
        self.requestInfo(from: newSearchData)
    }

    // MARK: - Private Functions
    private func requestInfo(from newSearchData: SearchData) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(newSearchData.city)&units=metric&appid=ad731160c722a3a494799520030786b5") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    self.weather = try JSONDecoder().decode(Weather.self, from: data)

                    if let weather = self.weather, let weatherInfo = weather.weather.first, let urlIcon = URL(string: "https://openweathermap.org/img/wn/\(weatherInfo.icon)@2x.png") {
                        print(weather)

                        self.delegate?.updateCoreData(
                            with: newSearchData,
                            and: WeatherData(
                                city: weather.name,
                                date: Date.now,
                                description: weather.weather.first?.main ?? "",
                                humidity: weather.main.humidity,
                                icon: urlIcon.absoluteString,
                                temperature: weather.main.temp,
                                wind: weather.wind.speed
                            )
                        )

                        self.delegate?.updateView(
                            city: weather.name,
                            description: weather.weather.first?.main ?? "",
                            icon: urlIcon,
                            temperature: "\(weather.main.temp.toInt())º",
                            humidity: "Humidity: \(weather.main.humidity)%",
                            windSpeed: "Wind: \(weather.wind.speed.toKmPerHour().toString()) km/h"
                        )
                    }
                } catch {
                    print(error.localizedDescription)
                    self.delegate?.showError()
                }
            }
        }
        task.resume()
    }
}
