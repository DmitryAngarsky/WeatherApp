//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 03.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation

class Forecast: Codable {
    
    var code: String?
    var list: [DataForecast]?
    var city: City?
}

class DataForecast: Codable {
    
    var dt: Double?
    var main: Main?
}

class Main: Codable {
    
    var temp: Float?
}

class City: Codable {
    
    var name: String = ""
    var country: String = ""
    var timezone: Int?
}
