//
//  MainViewController.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var profileImage: UIImageView!

    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    // MARK: - Private Functions
    private func setup() {
        self.setupProfileImage()
    }

    private func setupProfileImage() {
        self.profileImage.layer.cornerRadius = 124
    }

    private func createUIAlert() {
        let alert = UIAlertController(title: "Where would you like to go?", message: "Enter your destination", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].placeholder = "Destination"

        alert.addAction(UIAlertAction(title: "News", style: .default, handler: { [unowned alert] _ in
            self.factoryNewSearch(with: 1, alert.textFields![0].text, "Home", "News")
        }))
        alert.addAction(UIAlertAction(title: "Directions", style: .default, handler: { [unowned alert] _ in
            self.factoryNewSearch(with: 2, alert.textFields![0].text, "Home", "Directions")
        }))
        alert.addAction(UIAlertAction(title: "Weather", style: .default, handler: { [unowned alert] _ in
            self.factoryNewSearch(with: 3, alert.textFields![0].text, "Home", "Weather")
        }))

        self.present(alert, animated: true, completion: nil)
    }

    private func factoryNewSearch(with index: Int, _ city: String?, _ source: String, _ type: String) {
        guard let city = city else {
            self.showErrorAlert()
            return
        }

        let newSearchData = SearchData(city: city, source: source, type: type)
        self.create(searchData: newSearchData) { response in
            if response {
                self.navigationController?.tabBarController?.selectedIndex = index
            } else {
                self.showErrorAlert("Error", "Something wrong. Please try again.")
            }
        }
    }

    // MARK: - IBActions Functions
    @IBAction func didTapDiscoverWorld(_ sender: Any) {
        self.createUIAlert()
    }
}
