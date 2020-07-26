//
//  CurrencyViewViewController.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright (c) 2020 Sergey Markov. All rights reserved.
//

import UIKit

protocol CurrencyViewDisplayLogic: class {
  func displayData(viewModel: CurrencyView.Model.ViewModel.ViewModelData)
}

class CurrencyViewViewController: UIViewController, CurrencyViewDisplayLogic, CurrencyListSelect {

  var interactor: CurrencyViewBusinessLogic?
  var router: (NSObjectProtocol & CurrencyViewRoutingLogic)?
    
    private var currencyListViewModel = CurrencyListViewModel(cells: [])
    
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var currencyCostLabel: UILabel!
    @IBOutlet weak var currencyDetailsLabel: UILabel!
    @IBOutlet weak var currencyRefreshDateLabel: UILabel!
    @IBOutlet weak var currencyTitleView: UIView!
    @IBOutlet weak var currencyDetailsView: UIView!
    @IBOutlet weak var currencyListButton: UIButton!
    @IBOutlet weak var mainViewTopConstraint: NSLayoutConstraint!
    // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = CurrencyViewInteractor()
    let presenter             = CurrencyViewPresenter()
    let router                = CurrencyViewRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
    self.currencyTitleView.alpha = 0
    self.currencyDetailsView.alpha = 0
    self.currencyRefreshDateLabel.alpha = 0
    self.currencyListButton.alpha = 0
    
    interactor?.makeRequest(request: CurrencyView.Model.Request.RequestType.getCurrency)
  }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.mainViewTopConstraint.constant = 100
            self.view.layoutIfNeeded()
        })
    }
  
  func displayData(viewModel: CurrencyView.Model.ViewModel.ViewModelData) {

    switch viewModel {

    case .displaySelectedCurrency(currencyViewModel: let currencyViewModel):
        DispatchQueue.main.async {

            self.setTextWithLineSpacing(label: self.currencyTitleLabel, text: currencyViewModel.title, lineSpacing: 1)
            
            self.setTextWithLineSpacing(label: self.currencyCostLabel, text: currencyViewModel.cost, lineSpacing: -4)
            
            self.setTextWithLineSpacing(label: self.currencyDetailsLabel, text: self.currencyDetailsLabel.text!, lineSpacing: 1.21)
            
            self.setTextWithLineSpacing(label: self.currencyRefreshDateLabel, text: self.currencyRefreshDateLabel.text!, lineSpacing: 2)
            print(self.currencyTitleLabel)
            self.currencyTitleView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.currencyTitleView.alpha = 1
            }
        }
        
    case .displayCurrencies(currencyListViewModel: let currencyListViewModel):
        
        DispatchQueue.main.async {
            self.currencyListViewModel = currencyListViewModel
            
            UIView.animate(withDuration: 0.25) {
                self.currencyListButton.alpha = 1
            }
        }
        
    case .displayCurrencyDifference(currencyDifferenceViewModel: let currencyDifferenceViewModel):
        DispatchQueue.main.async {
            self.currencyDetailsLabel.text = currencyDifferenceViewModel.text
            self.currencyDetailsLabel.textColor = currencyDifferenceViewModel.textColor
            
            self.currencyDetailsView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.currencyDetailsView.alpha = 1
            }
        }
        
    case .displayUpdatedTime(updatedText: let updatedText):
        DispatchQueue.main.async {
            self.currencyRefreshDateLabel.text = updatedText
            
            self.currencyRefreshDateLabel.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.currencyRefreshDateLabel.alpha = 1
            }
        }
    }
  }
  
    @IBAction func currencyListButtonTap(_ sender: Any) {
        router?.openCurrencyList(currencyListViewModel: self.currencyListViewModel)
    }
    
    func setTextWithLineSpacing(label: UILabel, text: String, lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = .center

        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        label.attributedText = attrString
    }
    
    //MARK: CurrencyListSelect
    func selectCurrency(index: Int) {
        interactor?.makeRequest(request: CurrencyView.Model.Request.RequestType.selectCurrency(index: index))
    }
    
    //MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //open CurrencyListViewController
        if segue.identifier == "CurrencyListViewController" {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                self.mainViewTopConstraint.constant = 16
                self.view.layoutIfNeeded()
            })
        }
    }
}
