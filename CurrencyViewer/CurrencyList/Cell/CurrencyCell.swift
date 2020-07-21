//
//  CurrencyCell.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 20.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import UIKit

protocol CurrencyCellViewModel {
    var isSelect: Bool { get }
    var name: String { get }
}

class CurrencyCell: UITableViewCell {
    
    static let reuseId = "CurrencyCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func set(viewModel: CurrencyCellViewModel) {
        titleLabel.text = viewModel.name
        
        if viewModel.isSelect {
            titleLabel.font = UIFont(name: "Lato-Black", size: 28)
            titleLabel.textColor = UIColor(named: "CellTitleSelectColor")
        }else{
            titleLabel.font = UIFont(name: "Lato-Regular", size: 28)
            titleLabel.textColor = UIColor(named: "CellTitleUnselectColor")
        }
    }
}
