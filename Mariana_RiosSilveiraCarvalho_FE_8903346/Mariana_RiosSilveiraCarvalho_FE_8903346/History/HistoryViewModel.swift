//
//  HistoryViewModel.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-10.
//

import CoreData
import Foundation

protocol HistoryViewModelProtocol {
    var dataSource: [SearchHistoryData] { get }
    func load(data: [SearchHistoryData])
}

class HistoryViewModel: HistoryViewModelProtocol {
    // MARK: - Private(set) Properties
    private(set) var dataSource: [SearchHistoryData]

    // MARK: - Initializer
    init() {
        self.dataSource = []
    }

    // MARK: - Protocol Functions
    func load(data: [SearchHistoryData]) {
        self.dataSource = data
    }
}
