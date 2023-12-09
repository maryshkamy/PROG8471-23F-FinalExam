//
//  UIViewController+UIAlertController.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import UIKit

extension UIViewController {
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Please, enter a valid location.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }
}
