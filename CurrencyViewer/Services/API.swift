//
//  API.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

struct API {
    static let APIKey = "275c1f1bdca6c8f55bf08350cfc3dc1e"
    
    static let scheme = "http"
    static let host = "data.fixer.io"
    
    static let latest = "/api/latest"
    static let yesterday = "/api/"
    
    static let availableCurrency = "USD,EUR,RUB"
}
