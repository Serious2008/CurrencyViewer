//
//  CurrencyViewPresenter.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright (c) 2020 Sergey Markov. All rights reserved.
//

import UIKit

protocol CurrencyViewPresentationLogic {
  func presentData(response: CurrencyView.Model.Response.ResponseType)
}

class CurrencyViewPresenter: CurrencyViewPresentationLogic {
  weak var viewController: CurrencyViewDisplayLogic?
  
  func presentData(response: CurrencyView.Model.Response.ResponseType) {
    
    switch response {

    case .presentSelectedCurrency(currency: let currency):
        
        viewController?.displayData(viewModel: CurrencyView.Model.ViewModel.ViewModelData.displaySelectedCurrency(currencyViewModel: currencyViewModel(from: currency)))
        
    case .presentCurrencies(currencies: let currencies, selectedCurrency: let selectedCurrency):
        
        let cells = currencies.map { (currency) in
            cellViewModel(from: currency, isSelected: currency == selectedCurrency)
        }
        let currencyListViewModel = CurrencyListViewModel(cells: cells)
        viewController?.displayData(viewModel: CurrencyView.Model.ViewModel.ViewModelData.displayCurrencies(currencyListViewModel: currencyListViewModel))
    
    case .presentCurrencyDifference(difference: let difference, abbreviation: let abbreviation):

        viewController?.displayData(viewModel: CurrencyView.Model.ViewModel.ViewModelData.displayCurrencyDifference(currencyDifferenceViewModel:currencyDifferenceViewModel(from: difference, abbreviation: abbreviation)))
        
    case .presentUpdatedTime(time: let time):
        
        viewController?.displayData(viewModel: CurrencyView.Model.ViewModel.ViewModelData.displayUpdatedTime(updatedText: "\(NSLocalizedString("UPDATED AT", comment: "")) \(time)"))
    }
  
  }
    
    private func currencyDifferenceViewModel(from difference: Float, abbreviation: String) -> CurrencyDifferenceViewModel {
        
        let text = TextCreator().createDiffereneCurrencyCostText(difference: difference, currencyAbbreviation: abbreviation)
        
        let color: UIColor
        if difference < 0 {
            color = UIColor(named: "DetailsTitleNegativeColor")!
        }else{
            color = UIColor(named: "DetailsTitlePositiveColor")!
        }
        
        return CurrencyDifferenceViewModel(text: text,
                                           textColor: color)
    }
    
    private func currencyViewModel(from currency: CurrencyPair) -> CurrencyViewModel {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        formatter.numberStyle = .decimal

        return CurrencyViewModel(title: currency.title,
                                      cost: formatter.string(for: currency.cost) ?? "\(currency.cost)")
    }
    
    private func cellViewModel(from currency: CurrencyPair, isSelected: Bool) -> CurrencyListViewModel.Cell {
        return CurrencyListViewModel.Cell(isSelect: isSelected,
                                               name: currency.title)
    }
  
}
