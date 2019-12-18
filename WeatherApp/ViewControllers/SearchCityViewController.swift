//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 18.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import UIKit

protocol SearchCityViewControllerDelegate: class {
    func sendCityName(_ text: String)
}

class SearchCityViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate: SearchCityViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let cityNameString = searchBar.text, !cityNameString.isEmpty {
            
            delegate?.sendCityName(cityNameString)
            dismiss(animated: true)
        }
    }
}
