//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 03.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentTemperatureDescriptionLabel: UILabel!
    
    let cityName = "Samara"
    var forecast: Forecast?
    let dailyForecastTableViewCell = "DailyForecastTableViewCell"
    let currentTableViewCell = "CurrentTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.getForecast(cityName: cityName)
        {(result : Forecast?, error: Error?) in
                if let error = error {
                    print("\(error)")
                } else if let result = result {
                    self.updateData(result)
                    StorageManager.updateDB(result)
                }
        }
        
        self.navigationController?.view.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: dailyForecastTableViewCell, bundle: nil), forCellReuseIdentifier: dailyForecastTableViewCell)
        tableView.register(UINib(nibName: currentTableViewCell, bundle: nil), forCellReuseIdentifier: currentTableViewCell)
    }
    
    func updateData(_ result: Forecast) {

        let dailyForecast = DailyForecast(result)
        self.forecast = dailyForecast.getDailyForecast()
        
        self.navigationItem.title = result.city?.name
        self.currentTemperatureLabel.text = "\(String(Int(((forecast?.list.first?.main?.temp ?? 0) - 273.15).rounded())))°"
        self.currentTemperatureDescriptionLabel.text = forecast?.list.first?.weather.first?.weatherDescription.firstUppercased
        self.tableView.reloadData()
    }
    
    //MARK: -TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forecast?.list.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: dailyForecastTableViewCell, for: indexPath) as! DailyForecastTableViewCell
        let day = forecast?.list[indexPath.row].dt ?? 0
        let formatter = ForecastFormatter(forecast?.city?.timezone ?? 0, Double(day), forecast?.list[indexPath.row].main?.temp ?? 0)
        
        cell.monthDayLabel.text = formatter.dateConfigure(.monthDay)
        cell.weekDayLabel.text = formatter.dateConfigure(.weekday)
        cell.temperatureLabel.text = formatter.temperatureConfigure()
        
        if cell.weekDayLabel.text == "Суббота" || cell.weekDayLabel.text == "Воскресенье" {
            cell.weekDayLabel.textColor = UIColor.red
        } else {
            cell.weekDayLabel.textColor = UIColor.black
        }
        
        return cell
    }
}
    //MARK: -SearchCity ViewController Delegate

extension MainViewController: SearchCityViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? SearchCityViewController {
            dest.delegate = self
        }
    }
    
    func sendCityName(_ text: String) {
        
        APIManager.shared.getForecast(cityName: text)
        {(result : Forecast?, error: Error?) in
                if let error = error {
                    print("\(error)")
                } else if let result = result {
                    self.updateData(result)
                    StorageManager.updateDB(result)
                }
        }
    }
}


