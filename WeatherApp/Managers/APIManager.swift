//
//  APIManager.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 03.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

enum RequestParameters {
    
    case cityName(name: String)
    case location(location: CLLocationCoordinate2D)
    
    var params: Parameters {
        
        switch self {
        case .cityName(let name):
            return ["q": name]
        case .location(let location):
            return ["lat": location.latitude,
                    "lon": location.longitude]
        }
    }
}

final public class APIManager {
    
    public static let shared = APIManager()
    
    public func getForecast<T: Codable>(
        
        params: Parameters,
        handler: @escaping (_ forecast: T?, _ error: String?) -> Void) {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme     = "https"
        urlComponents.host       = "api.openweathermap.org"
        urlComponents.path       = "/data/2.5/forecast"
        urlComponents.queryItems = [URLQueryItem(name: "APPID", value: "ca47aa9c2b8fb3f74080e1ded2775ca8"),
                                    URLQueryItem(name: "lang", value: "ru")]
                                    
        guard let url = urlComponents.url else { return }
        
        request(url, parameters: params).validate().responseData() { response in
            
            switch response.result {
            case .success(let value):
                do {
                    let forecasts = try JSONDecoder.init().decode(T.self, from: value)
                    handler(forecasts, nil)
                } catch {
                    handler(nil, error.localizedDescription)
                }
            case .failure(let error):
                
                let errorMassege: String
                
                switch error.localizedDescription {
                case "The Internet connection appears to be offline.":
                    errorMassege = "Нет подключения к интернету"
                case "Response status code was unacceptable: 404.":
                    errorMassege = "Не удалось найти город"
                default:
                    errorMassege = "Не удалось соединиться с сервером"
                }

                handler(nil, errorMassege)
            }
        }
    }
}
