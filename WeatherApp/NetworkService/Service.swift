//
//  Service.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 23.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation

enum ServiceMethod: String {
    case get = "GET"
}

protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: ServiceMethod { get }
}

extension Service {

    public var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path

        if method == .get {

            guard let parameters = parameters as? [String: String] else {
                fatalError("Parameters for GET http method must conform to [String: String]")
            }
            
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        return urlComponents?.url
    }
}
