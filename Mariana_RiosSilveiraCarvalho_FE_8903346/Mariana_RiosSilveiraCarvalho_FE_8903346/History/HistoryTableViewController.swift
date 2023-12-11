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

        if let weather = history.weather {
            guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: "Weather", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
