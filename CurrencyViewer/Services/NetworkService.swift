//
//  NetworkService.swift
//  CurrencyViewer
//
//  Created by Sergey Markov on 19.07.2020.
//  Copyright © 2020 Sergey Markov. All rights reserved.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {

        let url = self.url(from: path, params: params)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        print(url)
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
                completion(data, error)
        })
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map {  URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
