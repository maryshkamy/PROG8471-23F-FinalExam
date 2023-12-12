//
//  News.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-11.
//

import Foundation

struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
