//
//  CurrencyListViewController.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 20.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import UIKit

protocol CurrencyListSelect {
  func selectCurrency(index: Int)
}

class CurrencyListViewController: UIViewController {

    var currencyListSelect: CurrencyListSelect?
    
    var currencyListViewModel = CurrencyListViewModel(cells: [])
    
    @IBOutlet weak var currencyListTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currencyListTable.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: CurrencyCell.reuseId)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyListViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseId, for: indexPath) as! CurrencyCell
        let cellViewModel = currencyListViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //unselect prevSelected Cell
        for index in 0..<currencyListViewModel.cells.count {
            if currencyListViewModel.cells[index].isSelect {
                currencyListViewModel.cells[index].isSelect = false
                break
            }
        }
        
        //select Cell
        currencyListViewModel.cells[indexPath.row].isSelect = true
        
        tableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
        
        currencyListSelect?.selectCurrency(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}
