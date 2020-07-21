//
//  CurrencyList.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 20.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

class CurrencyList {
    
    static func create(currencyAvailable: CurrencyAvailable) -> [Currency] {
        
        var currencyList = [Currency]()
        
        for firstCurrency in currencyAvailable.dictionaryOfCurrency() {
            
            let anotherCyrrencies = currencyAvailable.dictionaryOfCurrency().filter{ $0 != firstCurrency }
            for secondCurrency in anotherCyrrencies {
                
                let cost = calculateCost(firstCurrencyCost: firstCurrency.value, secondCurrencyCost: secondCurrency.value)
                
                let currency = Currency(isSelect: false,
                                        title: "\(firstCurrency.key) → \(secondCurrency.key)",
                                        cost: cost,
                                        abbreviation: firstCurrency.key)
                
                currencyList.append(currency)
            }
        }
        
        return currencyList
    }
    
    static func calculateCost(firstCurrencyCost: Float,
                              secondCurrencyCost: Float) -> Float {
        
        let k = 1 / firstCurrencyCost
        let result = k * secondCurrencyCost
        
        return result
    }
    
}
