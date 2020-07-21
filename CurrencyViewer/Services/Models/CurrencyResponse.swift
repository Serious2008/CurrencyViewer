//
//  CurrencyResponse.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

struct CurrencyResponse: Decodable {
    let success: Bool
    let base: String
    let date: Date
    let rates: CurrencyAvailable
}

struct CurrencyAvailable: Decodable {
    let RUB: Float
    let USD: Float
    let EUR: Float
    
    func arrayOfCurrency() -> [String] {
        return ["RUB","USD","EUR"]
    }
    
    func dictionaryOfCurrency() -> [String: Float] {
        return ["RUB": RUB, "USD": USD, "EUR": EUR]
    }
}

//"success": true,
//"timestamp": 1595099045,
//"base": "EUR",
//"date": "2020-07-18",
//"rates": {
//    "AED": 4.198103,
//    "AFN": 88.179055,
//    "ALL": 124.387711,
//}
