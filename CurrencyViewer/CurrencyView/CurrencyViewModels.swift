//
//  CurrencyViewModels.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright (c) 2020 Sergey Markov. All rights reserved.
//

import UIKit

enum CurrencyView {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getCurrency
        case selectCurrency(index: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentSelectedCurrency(currency: CurrencyPair)
        case presentCurrencies(currencies: [CurrencyPair], selectedCurrency: CurrencyPair)
        case presentCurrencyDifference(difference: Float, abbreviation: String)
        case presentUpdatedTime(time: String)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displaySelectedCurrency(currencyViewModel: CurrencyViewModel)
        case displayCurrencies(currencyListViewModel: CurrencyListViewModel)
        case displayCurrencyDifference(currencyDifferenceViewModel: CurrencyDifferenceViewModel)
        case displayUpdatedTime(updatedText: String)
      }
    }
  }
  
}

struct CurrencyViewModel {
    let title: String
    let cost: String
}

struct CurrencyListViewModel {
    struct Cell: CurrencyCellViewModel {
        var isSelect: Bool
        var name: String
    }
    var cells: [Cell]
}

struct CurrencyDifferenceViewModel {
    let text: String
    let textColor: UIColor
}
