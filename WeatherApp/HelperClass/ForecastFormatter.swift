//
//  ForecastFormatter.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 15.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased()  + dropFirst()
    }
}

enum DateFormat: String {
    
    case weekday = "EEEE"
    case monthDay = "MMMMd"
    case timeOfDay = "HH"
}

class ForecastFormatter {
    
    let timeZone: TimeZone
    let date: Double
    let temperature: Double
    
    init(_ timeZone: Int, _ date: Double, _ temperature: Double) {
        
        self.timeZone = TimeZone(secondsFromGMT: timeZone) ?? TimeZone.current
        self.date = date
        self.temperature = temperature
    }
    
    func dateConfigure(_ dateFormat: DateFormat) -> String {
        
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat.rawValue)
        dateFormatter.timeZone = timeZone
        
        let date = Date(timeIntervalSince1970: self.date)
        
        if calendar.isDateInToday(date) && dateFormat == .weekday {
            return "Сегодня"
        }
        
        if calendar.isDateInTomorrow(date) && dateFormat == .weekday {
            return "Завтра"
        }
        
        if dateFormat == .timeOfDay {
            
            let currentDate = Date()
            guard let timeOfDay = Int(dateFormatter.string(from: currentDate)) else { return ""}
            
            switch timeOfDay {
            case 0..<6:
                return "DarkBlueWeatherBackground"
            case 6..<12:
                return "LightBlueWeatherBackground"
            case 12..<18:
                return "BlueWeatherBackground"
            case 18..<24:
                return "OrangeWeatherBackground"
            default:
                break
            }
        }
        
        return dateFormatter.string(from: date).firstUppercased
    }
    
    func temperatureConfigure() -> String {
        
        return "\(String(Int((self.temperature - 273.15).rounded())))°"
    }
}
