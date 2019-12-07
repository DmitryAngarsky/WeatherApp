//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 03.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    

    let mainCell = "mainCell"
    let cityName = "London"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.getForecast(cityName: cityName)
        {(result : Forecast?, error: Error?) in
                if let error = error {
                    print("\(error)")
                } else if let result = result {
                    print("CityName: \(result.city?.name ?? "nil")\nCityCountry: \(result.city?.country ?? "nil")")
                    guard let timeZone = result.city?.timezone else { return }
                    
                    guard let array = result.list else { return }
                    for day in array {
                        guard let time = day.dt else { return }
                        print("\(TimeTransform.getDate(timeType: .weekday, unixTime: time, timeZone: timeZone))\n\(TimeTransform.getDate(timeType: .monthDay, unixTime: time, timeZone: timeZone))")
                        print(Date(timeIntervalSince1970: time))
                    }
                }
            }
    }
    
    //MARK: -TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCell, for: indexPath)
        cell.textLabel?.text = "Hello"
        
        return cell
    }
}
