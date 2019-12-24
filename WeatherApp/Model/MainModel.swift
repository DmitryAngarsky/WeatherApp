//
//  MainModel.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 23.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

class Main: Object, Codable {
    
    @objc dynamic var temp: Double = 0
}
