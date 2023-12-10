//
//  Double+Convertions.swift
//  Mariana_RiosSilveiraCarvalho_FE_8903346
//
//  Created by Mariana Rios Silveira Carvalho on 2023-12-09.
//

import Foundation

extension Double {

    // MARK: - Convert a Double to String with double precision
    func toString() -> String {
        return String(format: "%.2f", self)
    }

    // MARK: - Convert from meter per second to kilometer per hour
    func toKmPerHour() -> Double {
        return self < 0 ? 0 : (self * 3.6)
    }

    // MARK: - Convert a Double to Int
    func toInt() -> Int {
        return Int(self)
    }
}
