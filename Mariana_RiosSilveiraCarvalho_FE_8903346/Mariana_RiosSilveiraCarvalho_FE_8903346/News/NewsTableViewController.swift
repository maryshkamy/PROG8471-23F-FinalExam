//
//  NewsTableViewController.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-11.
//

import UIKit

class NewsTableViewController: UITableViewController {

    // MARK: - Private Properties
    private var viewModel: NewsViewModelProtocol

    // MARK: - Public Variables
    var searchHistoryData: SearchHistoryData?

    // MARK: - Initializer
    init() {
        self.viewModel = NewsViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = NewsViewModel()
        super.init(coder: coder)
    }

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
        self.setupViewModel()
        self.setupTableView()
    }

    private func setupViewModel() {
        self.viewModel.delegate = self
    }

    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    private func loadData() {
        if let searchHistoryData = self.searchHistoryData {
            self.viewModel.load(searchHistoryData)
        } else {
            self.retrieveNewSearch { newSearchData in
                if let data = newSearchData {
                    self.viewModel.didUpdateLocation(data, date: "")
                } else {
                    self.createNewSearchAlert { _ in
                        self.navigationController?.tabBarController?.selectedIndex = 0
                    }
                }
            }
        }
        self.tableView.reloadData()
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

            let newSearchData = SearchData(city: text, source: "News", type: "News")
            self.create(searchData: newSearchData) { response in
                if response {
                    self.viewModel.didUpdateLocation(newSearchData, date: "")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.title.text = self.viewModel.dataSource[indexPath.row].title
        cell.details.text = self.viewModel.dataSource[indexPath.row].description
        cell.source.text = self.viewModel.dataSource[indexPath.row].source.name
        cell.author.text = self.viewModel.dataSource[indexPath.row].author ?? "Unknown"

        return cell
    }
}

// MARK: - NewsViewModel Delegate
extension NewsTableViewController: NewsViewModelDelegate {
    func showError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Something wrong",
                message: "We could not find any data about this location. Please try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                self.navigationController?.tabBarController?.selectedIndex = 0
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func updateCoreData(with searchData: SearchData, and news: NewsData) {
        let data = SearchHistoryData(search: searchData, news: news, directions: nil, weather: nil)
        self.searchHistoryData = data
        self.create(searchHistory: data) { response in
            print(response)
        }
    }
}
