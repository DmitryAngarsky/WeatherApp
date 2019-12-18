//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 16.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import RealmSwift

class DailyForecast {
    
    let forecast: Forecast
    
    init(_ forecast: Forecast) {
        
        self.forecast = forecast
    }
    
    func getDailyForecast() -> Forecast {
        
        let dailyForecastList = List<DataForecast>()
        var tempArray: [DataForecast] = []

        for i in 0..<forecast.list.count - 1 {

            let date1 = Date(timeIntervalSince1970: Double(forecast.list[i].dt))
            let date2 = Date(timeIntervalSince1970: Double(forecast.list[i + 1].dt))

            var calendar = Calendar.current
            calendar.timeZone = TimeZone(secondsFromGMT: forecast.city?.timezone ?? 0)!
            let compareResult = calendar.compare(date1, to: date2, toGranularity: .day)
            
            switch compareResult {
            case .orderedSame:
                tempArray.append(forecast.list[i])
                if i == forecast.list.count - 2 {
                    tempArray.append(forecast.list[i + 1])
                    dailyForecastList.append(getDay(tempArray))
                }
            case .orderedAscending:
                tempArray.append(forecast.list[i])
                dailyForecastList.append(getDay(tempArray))
                tempArray.removeAll()
                if i == forecast.list.count - 2 {
                    tempArray.append(forecast.list[i + 1])
                    dailyForecastList.append(getDay(tempArray))
                }
            default:
                break
            }
        }
        
        forecast.list = dailyForecastList
        return forecast
    }
    
    func getDay(_ forecastArray: [DataForecast]) -> DataForecast {
        
        let forecast = DataForecast()
        forecast.dt = forecastArray.first?.dt ?? 0
        forecast.main = Main()
        forecast.main?.temp = forecastArray.compactMap({$0.main?.temp}).reduce(0.0, +) / Double(forecastArray.count)
        
        let middleValue = forecastArray.compactMap({$0.weather.first?.id})
            .reduce(into: [:]) { $0[$1, default: 0] += 1 }
            .sorted { $0.value < $1.value }
            .last?.key

        forecastArray.forEach({if $0.weather.first?.id == middleValue {forecast.weather = $0.weather}})

        return forecast
    }
}
