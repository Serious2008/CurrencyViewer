//
//  TextCreator.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 21.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

private enum CurrencyDescription: String, CustomStringConvertible {
    case RUB, EUR, USD
    
    var description: String {
      get {
        switch self {
          case .RUB:
            return NSLocalizedString("ruble", comment: "")
          case .EUR:
            return NSLocalizedString("euro", comment: "")
          case .USD:
            return NSLocalizedString("dollar", comment: "")
        }
      }
    }
    
}

private enum IncreaseDescription: String {
    case UP, DOWN
    
    var description: String {
      get {
        switch self {
          case .UP:
            return NSLocalizedString("increased", comment: "")
          case .DOWN:
            return NSLocalizedString("fell", comment: "")
        }
      }
    }
    
    static func increaseText(for value: Float) -> String {
        var increaseDescription = IncreaseDescription.UP
        if value < 0 {
            increaseDescription = .DOWN
        }

        return increaseDescription.description
    }
}


class TextCreator {
    
    func createDiffereneCurrencyCostText(difference: Float, currencyAbbreviation: String) -> String {

        let absValue = abs(difference)
        let roundValue = absValue.rounded(.up)
        
        let currencyDescription = (CurrencyDescription(rawValue: currencyAbbreviation)?.description) ?? currencyAbbreviation
        
        let localizedString = NSLocalizedString("currency diff percents", comment: "")
        
        let resultString = String.localizedStringWithFormat(localizedString,
                                                            currencyDescription ,
                                                            IncreaseDescription.increaseText(for: difference),
                                                            roundValue)

        return resultString
    }
}
