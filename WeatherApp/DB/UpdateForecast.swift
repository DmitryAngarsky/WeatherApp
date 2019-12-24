//
//  UpdateDB.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 24.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

extension StorageManager {
    
    static func updateDB(_ dataFromServer: Forecast) {
        
        guard let cityName = dataFromServer.city?.name else { return }
        dataFromServer.cityName = cityName
        let realmPathForecast = StorageManager.realm.objects(Forecast.self)

        if !realmPathForecast.compactMap({$0.cityName}).contains(dataFromServer.cityName) {
            
            StorageManager.addData(dataFromServer)
        } else {
            try! realm.write {

                guard let currentCityList = StorageManager.realm.object(ofType: Forecast.self, forPrimaryKey: dataFromServer.cityName)?.list else { return }
                realm.delete(currentCityList, cascading: true)
                realm.create(Forecast.self, value: ["cityName": dataFromServer.cityName!, "list": dataFromServer.list], update: .all)
            }
        }
    }
    
}
