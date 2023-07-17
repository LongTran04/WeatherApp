//
//  AlamofireAPIHelper.swift
//  WeatherApp
//
//  Created by Long Tran on 07/07/2023.
//

import Foundation
import Alamofire

class AlamofireAPIHelper {
    static var share = AlamofireAPIHelper()
    private let APIkey = "9dab31bf2ab32e86722c3e6f3e28ac2d"
    
    func getWeatherCity(with location: Location, completion: @escaping (Result<WeatherCity, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.lat)&lon=\(location.lon)&appid=\(APIkey)"
        AF.request(urlString).validate(statusCode: 200...299)
            .responseDecodable(of: WeatherCity.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCityByName(with cityName: String, completion: @escaping (Result<[City], Error>) -> Void) {
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=\(1)&appid=\(APIkey)"
        AF.request(urlString).validate(statusCode: 200...299)
            .responseDecodable(of: [City].self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
