//
//  CurrencyViewRouter.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright (c) 2020 Sergey Markov. All rights reserved.
//

import UIKit

protocol CurrencyViewRoutingLogic {
    func openCurrencyList(currencyListViewModel: CurrencyListViewModel)
}

class CurrencyViewRouter: NSObject, CurrencyViewRoutingLogic {

  weak var viewController: CurrencyViewViewController?
  
  // MARK: Routing
    func openCurrencyList(currencyListViewModel: CurrencyListViewModel) {
        
        let storyboard = UIStoryboard(name: "CurrencyListViewController", bundle: nil)
        let currencyListViewController = storyboard.instantiateViewController(withIdentifier: "CurrencyListViewController") as? CurrencyListViewController
        currencyListViewController?.currencyListViewModel = currencyListViewModel
        currencyListViewController?.currencyListSelect = viewController

        if let currencyListViewController = currencyListViewController {
            let segue = BottomCardSegue(identifier: "CurrencyListViewController", source: viewController!, destination: currencyListViewController)
            viewController?.prepare(for: segue, sender: nil)
            segue.perform()
        }
        

        
    }
  
}
