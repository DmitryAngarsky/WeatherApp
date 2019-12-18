//
//  APIManager.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 03.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import Alamofire

final public class APIManager {
    
    public static let shared = APIManager()
    
    public func getForecast<T: Codable>(
        cityName: String,
        handler: @escaping (_ forecast: T?, _ error: Error?) -> Void) {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme     = "https"
        urlComponents.host       = "api.openweathermap.org"
        urlComponents.path       = "/data/2.5/forecast"
        urlComponents.queryItems = [URLQueryItem(name: "q", value: cityName),
                                    URLQueryItem(name: "APPID", value: "ca47aa9c2b8fb3f74080e1ded2775ca8"),
                                    URLQueryItem(name: "lang", value: "ru")]
        guard let url = urlComponents.url else { return }
        
        request(url).validate().responseData() { response in
            
            switch response.result {
            case .success(let value):
                do {
                    let forecasts = try JSONDecoder.init().decode(T.self, from: value)
                    handler(forecasts, nil)
                } catch {
                    handler(nil, error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
