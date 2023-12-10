//
//  UIViewController+UIAlertController.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import UIKit

extension UIViewController {

    // MARK: - Show an alert error message
    func showErrorAlert(_ title: String = "Error", _ message: String = "Please, enter a valid location.") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }
}
