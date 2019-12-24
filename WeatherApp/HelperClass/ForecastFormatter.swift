//
//  ForecastFormatter.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 15.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation

enum DateFormat: String {
    
    case weekday = "EEEE"
    case monthDay = "MMMMd"
    case timeOfDay = "HH"
}

class ForecastFormatter {
    
    let timeZone: TimeZone
    let date: Date
    let temperature: Double
    let dateFormatter = DateFormatter()
    var calendar = Calendar.current
    
    init(_ timeZone: Int, _ date: Double, _ temperature: Double) {
        
        self.timeZone = TimeZone(secondsFromGMT: timeZone) ?? TimeZone.current
        self.date = Date(timeIntervalSince1970: date)
        self.temperature = temperature
        self.dateFormatter.locale = Locale(identifier: "ru_RU")
        self.dateFormatter.timeZone = self.timeZone
        self.calendar.timeZone = self.timeZone
    }
    
    func dateConfigure(_ dateFormat: DateFormat) -> String {
        
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat.rawValue)
        
        if calendar.isDateInToday(date) && dateFormat == .weekday {
            return "Сегодня"
        }
        
        if calendar.isDateInTomorrow(date) && dateFormat == .weekday {
            return "Завтра"
        }
        
        return dateFormatter.string(from: date).capitalized
    }
    
    func backgroundImageConfigure() -> String {
        
        dateFormatter.setLocalizedDateFormatFromTemplate(DateFormat.timeOfDay.rawValue)
        
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
            return ""
        }
    }
    
    func temperatureConfigure() -> String {
        
        return "\(String(Int(self.temperature.rounded())))°"
    }
}
