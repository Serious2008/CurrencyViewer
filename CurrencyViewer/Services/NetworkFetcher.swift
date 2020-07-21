//
//  NetworkFetcher.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getLatestCurrency(response: @escaping (CurrencyResponse?) -> Void)
    func getYesterdayCurrency(date: Date, response: @escaping (CurrencyResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getLatestCurrency(response: @escaping (CurrencyResponse?) -> Void) {
        
        let params = ["access_key": API.APIKey,
                      "symbols": API.availableCurrency]
        networking.request(path: API.latest, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: CurrencyResponse.self, from: data)
            response(decoded)
        }
    }
    
    func getYesterdayCurrency(date: Date, response: @escaping (CurrencyResponse?) -> Void) {
        
        let params = ["access_key": API.APIKey,
                      "symbols": API.availableCurrency]
        
        let yesterday = date.yesterday().toString(dateFormat: "yyyy-MM-dd")
        let path = "\(API.yesterday)\(yesterday)"
        
        networking.request(path: path, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: CurrencyResponse.self, from: data)
            response(decoded)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder.customDateDecoder
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}

extension JSONDecoder {
    enum DateDecodeError: String, Error {
        case invalidDate
    }

    static var customDateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateStr) {
                return date
            }
            throw DateDecodeError.invalidDate
        })

        return decoder
    }
}
