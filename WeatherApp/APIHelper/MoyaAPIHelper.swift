//
//  MoyaAPIHelper.swift
//  WeatherApp
//
//  Created by Long Tran on 07/07/2023.
//

import Foundation
import Moya

class MoyaAPIHelper {
    static var share = MoyaAPIHelper()
    private let provider = MoyaProvider<MoyaAPI>()
    
    func getWeatherCity(with location: Location, completion: @escaping (Result<WeatherCity, Error>) -> Void) {
        provider.request(.weatherCity(location: location)) { result in
            switch result {
            case .success(let response):
                do {
                    let weatherCity = try JSONDecoder().decode(WeatherCity.self, from: response.data)
                    completion(.success(weatherCity))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCityByName(with cityName: String, completion: @escaping (Result<[City], Error>) -> Void) {
        provider.request(.cityByName(cityName: cityName)) { result in
            switch result {
            case .success(let response):
                do {
                    let cities = try JSONDecoder().decode([City].self, from: response.data)
                    completion(.success(cities))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWeatherNextDay(with location: Location, completion: @escaping (Result<WeatherNextDay, Error>) -> Void) {
        provider.request(.weatherNextDay(location: location)) { result in
            switch result {
            case .success(let response):
                do {
                    let weatherNextDay = try JSONDecoder().decode(WeatherNextDay.self, from: response.data)
                    completion(.success(weatherNextDay))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum MoyaAPI {
    case weatherCity(location: Location)
    case cityByName(cityName: String)
    case weatherNextDay(location: Location)
}

extension MoyaAPI: TargetType {
    
    var APIkey: String {
        return "9dab31bf2ab32e86722c3e6f3e28ac2d"
    }
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/")!
    }
    
    var path: String {
        switch self {
        case .weatherCity:
            return "data/2.5/weather"
        case .cityByName:
            return "geo/1.0/direct"
        case .weatherNextDay:
            return "data/2.5/forecast"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .weatherCity(let location):
            let parameters: [String: Any] = [
                "lat" : "\(location.lat)",
                "lon" : "\(location.lon)",
                "appid": "\(APIkey)"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .cityByName(let cityName):
            let parameters: [String: Any] = [
                "q" : "\(cityName)",
                "limit" : "1",
                "appid": "\(APIkey)"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case.weatherNextDay(let location):
            let parameters: [String: Any] = [
                "lat" : "\(location.lat)",
                "lon" : "\(location.lon)",
                "appid": "\(APIkey)"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
