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

private enum CountDescription: String {
    case SINGLE, PLURAL, PLURAL2
    
    var description: String {
      get {
        switch self {
          case .SINGLE:
            return NSLocalizedString("percent", comment: "")
          case .PLURAL:
            return NSLocalizedString("percents", comment: "")
        case .PLURAL2:
            return NSLocalizedString("percents_2", comment: "")
        }
      }
    }
    
    static func countText(for value: Int) -> String {
        var countDescription = CountDescription.SINGLE
        switch value {
        case 1:
            countDescription = .SINGLE
        case 2...4:
            countDescription = .PLURAL
        case 0, 5...19:
            countDescription = .PLURAL2
        default:
            print("CountDescription error")
        }

        return countDescription.description
    }
}

class TextCreator {
    
    func createDiffereneCurrencyCostText(difference: Float, currencyAbbreviation: String) -> String {
        
        let absValue = abs(difference)
        let roundValue = absValue.rounded(.up)
        
        var numberForCountDescription = Int(roundValue) % 100
        
        if numberForCountDescription > 19 {
            numberForCountDescription = numberForCountDescription % 10
        }
        
        let mainText = "\(NSLocalizedString("Since yesterday", comment: "")) \(CurrencyDescription.init(rawValue: currencyAbbreviation)!) \(IncreaseDescription.increaseText(for: difference)) \(NSLocalizedString("by", comment: "")) \(Int(roundValue)) \(CountDescription.countText(for: numberForCountDescription))"
        
        return mainText
    }
}
