//
//  StorageService.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 20.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

class StorageService {
    
    func saveCurrency(currency: CurrencyPair) {
        let defaults = UserDefaults.standard
        defaults.set(currency.title, forKey: "SelectedCurrencyTitle")
        defaults.set(currency.cost, forKey: "SelectedCurrencyCost")
    }
    
    func loadCurrency() -> CurrencyPair? {
        
        let defaults = UserDefaults.standard
        if let currencyTitle = defaults.string(forKey: "SelectedCurrencyTitle") {
            
            let currencyCost = defaults.float(forKey: "SelectedCurrencyCost")
            return CurrencyPair(title: currencyTitle , cost: currencyCost, abbreviation: "")
            
        }else { return nil }
    }
}
