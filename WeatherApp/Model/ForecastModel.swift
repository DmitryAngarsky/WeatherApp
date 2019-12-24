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
    
    @objc dynamic var city: City?
    @objc dynamic var cityName: String?
    var list = List<DataForecast>()
    
    override class func primaryKey() -> String? {
        return "cityName"
    }
}
