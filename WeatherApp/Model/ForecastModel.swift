//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 03.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

class Forecast: Object, Codable {
    
    @objc dynamic var cod: String = ""
    @objc dynamic var city: City?
    @objc dynamic var cityName: String?
    var list = List<DataForecast>()
    
    override class func primaryKey() -> String? {
        return "cityName"
    }
}

class City: Object, Codable {
    
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    @objc dynamic var timezone: Int = 0
}

class DataForecast: Object, Codable {
    
    @objc dynamic var dt: Int = 0
    @objc dynamic var main: Main?
    var weather = List<Weather>()
}

class Main: Object, Codable {
    
    @objc dynamic var temp: Double = 0
}

class Weather: Object, Codable {
    
    @objc dynamic var weatherDescription = ""
    @objc dynamic var id = 0
    
    private enum CodingKeys : String, CodingKey {
        case weatherDescription = "description"
        case id = "id"
    }
}
