//
//  NewsTableViewCell.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-11.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets Weather
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var author: UILabel!
    
    // MARK: - UITableViewCell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
