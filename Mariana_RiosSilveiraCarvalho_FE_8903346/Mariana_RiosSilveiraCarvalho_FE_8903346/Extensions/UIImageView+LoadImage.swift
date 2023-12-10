//
//  UIImageView+LoadImage.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import UIKit
import Foundation

extension UIImageView {

    // MARK: - Convert a valid URL string into UIImage
    func load(from url: URL, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    completion()
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImage(systemName: "cloud")
                    completion()
                }
            }
        }
    }
}
