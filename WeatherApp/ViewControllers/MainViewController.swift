//
//  ViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 03.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class MainViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentTemperatureDescriptionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let userDefaultsKey = "lastCityName"

    var forecast: Forecast? {
        return StorageManager.realm.object(ofType: Forecast.self,
                                           forPrimaryKey: UserDefaults.standard.string(forKey: self.userDefaultsKey))
    }
    
    let locationManager = CLLocationManager()
    let spinner = UIActivityIndicatorView(style: .large)
    let dailyForecastTableViewCell = "DailyForecastTableViewCell"
    
    let cityImageOnRequestError = UIImage(named: "City")
    let cityImageViewOnRequestError = UIImageView()
    let viewHiddingTableView = UIView()
    
    //MARK: -ViewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestResultIsHidden(true)
        
        viewHiddingTableView.backgroundColor = .white
        viewHiddingTableView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width,
                                                        height: tableView.frame.height)
        
        cityImageViewOnRequestError.frame = CGRect(x: 0, y: 130, width: 350,
                                                                 height: 200)
        cityImageViewOnRequestError.center.x = viewHiddingTableView.center.x
        cityImageViewOnRequestError.image = cityImageOnRequestError
        
        spinner.center.x = viewHiddingTableView.center.x
        spinner.center.y = 200
        
        viewHiddingTableView.addSubview(spinner)
        viewHiddingTableView.addSubview(cityImageViewOnRequestError)
        tableView.addSubview(viewHiddingTableView)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.navigationController?.view.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: dailyForecastTableViewCell, bundle: nil), forCellReuseIdentifier: dailyForecastTableViewCell)
    }
    
    @IBAction func sendLocation(_ sender: Any) {
        
        requestResultIsHidden(true)
        locationManager.startUpdatingLocation()
    }
    //MARK: -RequestErrorHandling Method
    func requestErrorHandling(_ error: Error) {
        
        if forecast == nil {
            
            viewHiddingTableView.isHidden = false
            cityImageViewOnRequestError.isHidden = false
            navigationItem.title = "Ошибка"
        } else {
            
            let forecastFormatter = ForecastFormatter(forecast?.city?.timezone ?? 0,
                                                      Double(forecast?.list.first?.dt ?? 0),
                                                      forecast?.list.first?.main?.temp ?? 0)
            requestResultIsHidden(false)
            self.navigationItem.title = forecast?.city?.name
            self.currentTemperatureLabel.text = forecastFormatter.temperatureConfigure()
            self.currentTemperatureDescriptionLabel.text = self.forecast?.list.first?.weather.first?.weatherDescription.capitalized
        }
        
        let actionSheet = UIAlertController(title: "Ошибка",
                                            message: "\(error.localizedDescription)",
                                            preferredStyle: .alert)
        let okeyAction = UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil)
        actionSheet.addAction(okeyAction)
        
        present(actionSheet, animated: true)
    }
    //MARK: -UpdateData Method
    func updateData(_ result: Forecast) {
        let dailyForecast = DailyForecast(result)
        let forecastFormatter = ForecastFormatter(result.city?.timezone ?? 0,
                                                  Double(result.list.first?.dt ?? 0),
                                                  result.list.first?.main?.temp ?? 0)
        UserDefaults.standard.set(result.city?.name ?? "",
                                  forKey: self.userDefaultsKey)
        UserDefaults.standard.synchronize()
        
        StorageManager.updateDB(dailyForecast.getDailyForecast())
        requestResultIsHidden(false)
        backgroundImageView.image = UIImage(named: forecastFormatter.backgroundImageConfigure())
        navigationItem.title = result.city?.name
        currentTemperatureLabel.text = forecastFormatter.temperatureConfigure()
        currentTemperatureDescriptionLabel.text = forecast?.list.first?.weather.first?.weatherDescription.capitalized
        
        self.tableView.reloadData()
    }
    //MARK: -Method Hidding Results Of Request
    func requestResultIsHidden(_ isHidden: Bool) {
        switch isHidden {
        case true:
            navigationItem.title = "Загрузка..."
            currentTemperatureLabel.isHidden = isHidden
            currentTemperatureDescriptionLabel.isHidden = isHidden
            cityImageViewOnRequestError.isHidden = isHidden
            viewHiddingTableView.isHidden = isHidden
            spinner.startAnimating()
        case false:
            currentTemperatureLabel.isHidden = isHidden
            currentTemperatureDescriptionLabel.isHidden = isHidden
            viewHiddingTableView.isHidden = !isHidden
            spinner.stopAnimating()
            spinner.isHidden = !isHidden
        }
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
        
        if formatter.calendar.isDateInWeekend(formatter.date) {
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
        
        if let destination = segue.destination as? SearchCityViewController {
            destination.delegate = self
        }
    }
    
    func sendCityName(_ name: String) {
        
        requestResultIsHidden(true)
        
        let manager = APIManager<WeatherService>()
        manager.getForecast(service: .cityName(name: name))
        { [weak self] (result: Result<Forecast, Error>) -> Void in
            switch result {
            case .success(let result):
                self?.updateData(result)
            case .failure(let error):
                self?.requestErrorHandling(error)
            }
        }
    }
    
    //MARK: -CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last!
        
        if currentLocation.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            let coordinates = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,
                                                         currentLocation.coordinate.longitude)
            
            let manager = APIManager<WeatherService>()
            manager.getForecast(service: .location(location: coordinates))
            { [weak self] (result: Result<Forecast, Error>) -> Void in
                switch result {
                case .success(let result):
                    self?.updateData(result)
                case .failure(let error):
                    self?.requestErrorHandling(error)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        requestErrorHandling(error)
    }
}
