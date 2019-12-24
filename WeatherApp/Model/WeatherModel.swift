//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 23.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object, Codable {
    
    @objc dynamic var weatherDescription = ""
    @objc dynamic var id = 0
    
    private enum CodingKeys : String, CodingKey {
        case weatherDescription = "description"
        case id = "id"
    }
}
