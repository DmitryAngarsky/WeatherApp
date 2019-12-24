//
//  APIManager.swift
//  WeatherApp
//
//  Created by Дмитрий Тараканов on 03.12.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import Alamofire

final class APIManager<U: Service> {
    
    public func getForecast<T: Decodable>(
        service: U,
        handler: @escaping (Swift.Result<T, Error>) -> Void) {
        
        guard let url = service.url else { return }
        
        request(url).validate().responseData() { response in
            
            switch response.result {
            case .success(let value):
                do {
                    let forecasts = try JSONDecoder.init().decode(T.self, from: value)
                    handler(.success(forecasts))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
