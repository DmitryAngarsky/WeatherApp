//
//  TimeTransform.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 04.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//
import Foundation

class TimeTransform {
    
    enum TimeType {
        
        case weekday
        case monthDay
    }
    
    static func getDate(timeType: TimeType, unixTime: Double, timeZone: Int) -> String {
        
        let date     = Date(timeIntervalSince1970: unixTime)
        let calendar = Calendar.current.dateComponents(in: TimeZone.init(secondsFromGMT: timeZone) ?? TimeZone.current, from: date)
        let day      = String(calendar.day ?? 0)
        let month    = calendar.month
        let weekday  = calendar.weekday
        
        switch timeType {
        case .monthDay:
            switch month {
                         
                case 1:
                    return day + " Января"
                case 2:
                    return day + " Февраля"
                case 3:
                    return day + " Марта"
                case 4:
                    return day + " Апреля"
                case 5:
                    return day + " Мая"
                case 6:
                    return day + " Июня"
                case 7:
                    return day + " Июля"
                case 8:
                    return day + " Августа"
                case 9:
                    return day + " Сентября"
                case 10:
                    return day + " Октября"
                case 11:
                    return day + " Ноября"
                case 12:
                    return day + " Декабря"
                default:
                    return "nil"
            }
            
        case .weekday:
            switch weekday {
                
                case 1:
                    return "Воскресенье"
                case 2:
                    return "Понедельник"
                case 3:
                    return "Вторник"
                case 4:
                    return "Среда"
                case 5:
                    return "Четверг"
                case 6:
                    return "Пятница"
                case 7:
                    return "Суббота"
                default:
                    return "undefined"
            }
        }
    }
}
