//
//  CityModel.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 23.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object, Codable {
    
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    @objc dynamic var timezone: Int = 0
}

