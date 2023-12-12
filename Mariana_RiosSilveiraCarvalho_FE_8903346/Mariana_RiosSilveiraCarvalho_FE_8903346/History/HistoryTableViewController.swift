//
//  HistoryTableViewController.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-10.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    // MARK: - Private Properties
    private let viewModel: HistoryViewModelProtocol = HistoryViewModel()

    // MARK: - UITableViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // MARK - Private Functions
    private func setup() {
        self.setupTableView()
    }

    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    private func loadData() {
        self.retrieveSearchHistory { response in
            self.viewModel.load(data: response)
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel.dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let history = self.viewModel.dataSource[indexPath.row]

        if let news = history.news {
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "News", for: indexPath) as? NewsHistoryTableViewCell else { return UITableViewCell() }
            newsCell.type.text = history.search.type
            newsCell.city.text = history.search.city
            newsCell.source.text = "From \(history.search.source)"
            newsCell.newsTitle.text = news.title
            newsCell.newsDetails.text = news.description
            newsCell.newsSource.text = news.source
            newsCell.newsAuthor.text = news.author
            return newsCell
        }

        if let weather = history.weather {
            guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: "Weather", for: indexPath) as? WeatherHistoryTableViewCell else { return UITableViewCell() }
            weatherCell.type.text = history.search.type
            weatherCell.source.text = "From \(history.search.source)"
            weatherCell.city.text = weather.city
            weatherCell.temperature.text = "\(weather.temperature.toInt())º"
            weatherCell.humidity.text = "Humidity: \(weather.humidity)%"
            weatherCell.wind.text = "Wind: \(weather.wind.toKmPerHour().toString()) km/h"
            weatherCell.dateTime.text = weather.date.formatted()
            return weatherCell
        }

        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = self.viewModel.dataSource[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if history.news != nil {
            let destination = storyboard.instantiateViewController(withIdentifier: "News") as! NewsTableViewController
            destination.searchHistoryData = history
            self.navigationController?.pushViewController(destination, animated: true)
        }

        if let weather = history.weather {
            let destination = storyboard.instantiateViewController(withIdentifier: "Weather") as! WeatherViewController
            destination.weatherData = weather
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let data = self.viewModel.dataSource[indexPath.row]
            self.delete(searchHistory: data) { response in
                if response {
                    self.viewModel.remove(index: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    self.showErrorAlert("Error", "We could not delete the data. Please try again.")
                }
            }
        }
    }
}
