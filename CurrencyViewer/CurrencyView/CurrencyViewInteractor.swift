//
//  CurrencyViewInteractor.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright (c) 2020 Sergey Markov. All rights reserved.
//

import UIKit

protocol CurrencyViewBusinessLogic {
  func makeRequest(request: CurrencyView.Model.Request.RequestType)
}

class CurrencyViewInteractor: CurrencyViewBusinessLogic {

  var presenter: CurrencyViewPresentationLogic?
  var service: CurrencyViewService?
    var storageService: StorageService?
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    private var currencyList = [Currency]()
    private var yesterdayCurrencyList = [Currency]()
    private var selectedCurrency : Currency?
  
  func makeRequest(request: CurrencyView.Model.Request.RequestType) {
    if service == nil {
      service = CurrencyViewService()
        
    }
    
    if storageService == nil {
        storageService = StorageService()
    }
    
    switch request {

    case .getCurrency:
        
        if let selectedCurrency = storageService?.loadCurrency() {
            //show currency
            presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentSelectedCurrency(currency: selectedCurrency))
        }

        
        fetcher.getLatestCurrency { [weak self] (currencyResponse) in
            guard let currencyResponse = currencyResponse else { return }
            
            self?.currencyList = CurrencyList.create(currencyAvailable: currencyResponse.rates)
            
            if let selectedCurrency = self?.storageService?.loadCurrency() {
                //find and selectCurrency
                var selectedCurrencyIndex: Int = -1
                for index in 0..<(self?.currencyList.count)! {
                    if (self?.currencyList[index].title)! == selectedCurrency.title {
                        self?.currencyList[index].isSelect = true
                        selectedCurrencyIndex = index
                        break
                    }
                }

                if selectedCurrencyIndex >= 0 {
                    //show currency
                    self?.selectedCurrency = self?.currencyList[selectedCurrencyIndex]
                    self?.prepareCurrencyList(index: selectedCurrencyIndex)
                } else {
                    //select first currency
                    self?.selectFirst(currencyList: self!.currencyList)
                    self?.prepareCurrencyList(index: 0)
                }
                
            } else {
                //select first currency
                self?.selectFirst(currencyList: self!.currencyList)
                self?.prepareCurrencyList(index: 0)
            }
            
            self?.storageService?.saveCurrency(currency: (self?.selectedCurrency)!)
            
            //get updatedTime
            self?.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentUpdatedTime(time: Date().toString(dateFormat: "HH:mm")))
            
            //load yesterday currencies
            self?.fetcher.getYesterdayCurrency(date: currencyResponse.date) { [weak self] (yesterdayCurrencyResponse) in
                guard let yesterdayCurrencyResponse = yesterdayCurrencyResponse else { return }
                
                self?.yesterdayCurrencyList = CurrencyList.create(currencyAvailable: yesterdayCurrencyResponse.rates)
                
                let yesterdaySelCurrency = self?.yesterdayCurrencyList.filter { $0 == self?.selectedCurrency }
                
                if let yesterdaySelCurrency = yesterdaySelCurrency?.first,
                    let selectedCurrency = self?.selectedCurrency {
                    
                    let increase = selectedCurrency.cost - yesterdaySelCurrency.cost
                    let percentage = (increase/yesterdaySelCurrency.cost) * 100

                    self?.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentCurrencyDifference(difference: percentage, abbreviation: (self?.selectedCurrency?.getAbbreviation())!))
                }
            }
        }
    case .selectCurrency(index: let index):
        //unselect prevSelected Cell
        for index in 0..<currencyList.count {
            if currencyList[index].isSelect {
                currencyList[index].isSelect = false
                break
            }
        }
        
        currencyList[index].isSelect = true
        self.selectedCurrency = currencyList[index]
        
        prepareCurrencyList(index: index)
        
        self.storageService?.saveCurrency(currency: self.selectedCurrency!)
        
        //get yestarday currency
        let yesterdaySelCurrency = self.yesterdayCurrencyList.filter { $0 == self.selectedCurrency }
        
        if let yesterdaySelCurrency = yesterdaySelCurrency.first,
            let selectedCurrency = self.selectedCurrency {
            
            let increase = selectedCurrency.cost - yesterdaySelCurrency.cost
            let percentage = (increase/yesterdaySelCurrency.cost) * 100

            self.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentCurrencyDifference(difference: percentage, abbreviation: (self.selectedCurrency?.getAbbreviation())!))
        }
    }
  }
    
    private func prepareCurrencyList(index: Int) {
        
        self.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentSelectedCurrency(currency: self.currencyList[index]))
        self.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentCurrencies(currencies: self.currencyList))
    }
    
    private func selectFirst(currencyList: [Currency]) {
        
        if (currencyList.first != nil) {
            self.currencyList[0].isSelect = true
            self.selectedCurrency = currencyList[0]
        }
    }
  
}
