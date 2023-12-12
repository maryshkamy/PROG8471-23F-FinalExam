//
//  WeatherTableViewCell.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-10.
//

import UIKit

class WeatherHistoryTableViewCell: UITableViewCell {

    // MARK: - @IBOutlets Weather
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var dateTime: UILabel!

    // MARK: - UITableViewCell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
