//
//  Date + Yesterday.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 20.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

extension Date {
    
    func yesterday() -> Date {
     
       var dateComponents = DateComponents()
       dateComponents.setValue(-1, for: .day) // -1 day
     
       let yesterday = Calendar.current.date(byAdding: dateComponents, to: self) // Add the DateComponents
     
       return yesterday!
    }
    
    func toString( dateFormat format  : String ) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }

    
}
