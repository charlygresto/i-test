//
//  Extensions.swift
//  i-test
//
//  Created by it on 10/11/2021.
//

import Foundation

extension Double {

    /// Formats the receiver as a currency string using the specified three digit currencyCode. Currency codes are based on the ISO 4217 standard.
    func formatAsCurrency(currencyCode: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = currencyCode
        currencyFormatter.maximumFractionDigits = floor(self) == self ? 0 : 2
//        return currencyFormatter.stringFromNumber(NSNumber(self))
        return "tet"
    }
}
