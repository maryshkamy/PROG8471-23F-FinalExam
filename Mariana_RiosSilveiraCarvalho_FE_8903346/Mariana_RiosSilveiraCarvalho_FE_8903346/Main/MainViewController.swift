//
//  MainViewController.swift
//  Mariana_RiosSilveiraCarvalho_FE_ 8903346
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
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        alert.addAction(UIAlertAction(title: "Go", style: .default, handler: { [unowned alert] _ in
//            print(alert.textFields![0].text)
//        }))
        alert.addAction(UIAlertAction(title: "News", style: .default, handler: { [unowned alert] _ in
            guard let text = alert.textFields![0].text, text != "" else {
                self.showErrorAlert()
                return
            }
            self.navigationController?.tabBarController?.selectedIndex = 1
        }))
        alert.addAction(UIAlertAction(title: "Directions", style: .default, handler: { [unowned alert] _ in
            guard let text = alert.textFields![0].text, text != "" else {
                print("String vazia")
                return
            }
            self.navigationController?.tabBarController?.selectedIndex = 2
        }))
        alert.addAction(UIAlertAction(title: "Weather", style: .default, handler: { [unowned alert] _ in
            guard let text = alert.textFields![0].text, text != "" else {
                print("String vazia")
                return
            }
            self.navigationController?.tabBarController?.selectedIndex = 3
        }))

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - IBActions Functions
    @IBAction func didTapDiscoverWorld(_ sender: Any) {
        self.createUIAlert()
    }
}
