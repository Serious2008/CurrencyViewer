//
//  CurrencyPair.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 20.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

struct CurrencyPair: Equatable {
    let title: String
    let cost: Float
    var abbreviation: String
    
    static func == (lhs: CurrencyPair, rhs: CurrencyPair) -> Bool {
        return lhs.title == rhs.title
    }
    
    mutating func setAbbreviation(abbreviation: String) {
        self.abbreviation = abbreviation
    }
    
    func getAbbreviation() -> String {
        return self.abbreviation
    }
}
