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
  var service: CurrencyViewService? = CurrencyViewService()
    lazy var storageService: StorageService? = StorageService()
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    private var currencyList = [CurrencyPair]()
    private var yesterdayCurrencyList = [CurrencyPair]()
    private var selectedCurrency : CurrencyPair?
  
  func makeRequest(request: CurrencyView.Model.Request.RequestType) {

    switch request {

    case .getCurrency:
        
        if let selectedCurrency = storageService?.loadCurrency() {
            //show currency
            presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentSelectedCurrency(currency: selectedCurrency))
        }

        
        fetcher.getLatestCurrency { [weak self] (currencyResponse) in
            guard let currencyResponse = currencyResponse,
                    let self = self else { return }
            
            self.currencyList = CurrencyList.create(currencyAvailable: currencyResponse.rates)
            
            if let selectedCurrency = self.storageService?.loadCurrency() {
                //find selected currency
                self.selectedCurrency = nil
                self.selectedCurrency = (self.currencyList.filter{ $0 == selectedCurrency }).first

                //show currency
                if self.selectedCurrency == nil {
                    self.selectFirst(currencyList: self.currencyList)
                }
                self.prepareCurrencyList(selectedCurrency: self.selectedCurrency!)
                
            } else {
                //select first currency
                self.selectFirst(currencyList: self.currencyList)
                self.prepareCurrencyList(selectedCurrency: self.selectedCurrency!)
            }
            
            self.storageService?.saveCurrency(currency: (self.selectedCurrency)!)
            
            //get updatedTime
            self.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentUpdatedTime(time: Date().toString(dateFormat: "HH:mm")))
            
            //load yesterday currencies
            self.fetcher.getYesterdayCurrency(date: currencyResponse.date) { [weak self] (yesterdayCurrencyResponse) in
                guard let yesterdayCurrencyResponse = yesterdayCurrencyResponse,
                        let self = self else { return }
                
                self.yesterdayCurrencyList = CurrencyList.create(currencyAvailable: yesterdayCurrencyResponse.rates)
                
                let yesterdaySelCurrency = self.yesterdayCurrencyList.filter { $0 == self.selectedCurrency }
                
                if let yesterdaySelCurrency = yesterdaySelCurrency.first,
                    let selectedCurrency = self.selectedCurrency {
                    
                    //calculate diff in percent
                    let increase = selectedCurrency.cost - yesterdaySelCurrency.cost
                    let percentage = (increase/yesterdaySelCurrency.cost) * 100

                    self.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentCurrencyDifference(difference: percentage, abbreviation: self.selectedCurrency?.getAbbreviation() ?? "UNKNOWN"))
                }
            }
        }
    case .selectCurrency(index: let index):
        
        self.selectedCurrency = currencyList[index]
        
        prepareCurrencyList(selectedCurrency: self.selectedCurrency!)
        
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
    
    private func prepareCurrencyList(selectedCurrency: CurrencyPair) {
        
        self.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentSelectedCurrency(currency: selectedCurrency))
        self.presenter?.presentData(response: CurrencyView.Model.Response.ResponseType.presentCurrencies(currencies: self.currencyList, selectedCurrency: selectedCurrency))
    }
    
    private func selectFirst(currencyList: [CurrencyPair]) {
        
        if (currencyList.first != nil) {
            self.selectedCurrency = currencyList[0]
        }
    }
  
}
