//
//  Weather.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import Foundation

struct Weather: Codable {
    let coordinate: Coordinate
    let weather: [WeatherInfo]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int

    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dt
        case sys
        case timezone, id
        case name
        case cod
    }
}
