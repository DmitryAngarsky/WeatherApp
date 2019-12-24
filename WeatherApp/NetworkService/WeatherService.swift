//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 23.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import CoreLocation

enum WeatherService {
    case cityName(name: String)
    case location(location: CLLocationCoordinate2D)
}

extension WeatherService: Service {
    var baseURL: String {
        return "https://api.openweathermap.org"
    }
    
    var path: String {
        return "/data/2.5/forecast"
    }

    var parameters: [String: Any]? {
       
        var params: [String: Any] = ["APPID": "ca47aa9c2b8fb3f74080e1ded2775ca8",
                                     "lang": "ru",
                                     "units": "metric"]
        
        switch self {
        case .cityName(let name):
            params["q"] = name
        case .location(let location):
            params["lat"] = String(location.latitude)
            params["lon"] = String(location.longitude)
        }
        return params
    }

    var method: ServiceMethod {
        return .get
    }
}
