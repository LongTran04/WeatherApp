//
//  RxAPIHelper.swift
//  WeatherApp
//
//  Created by Long Tran on 07/07/2023.
//

import Foundation
import RxSwift
import RxCocoa

class RxAPIHelper {
    static var share = RxAPIHelper()
    private let APIkey = "9dab31bf2ab32e86722c3e6f3e28ac2d"
    
    func getWeatherCity(with location: Location) -> Observable<WeatherCity> {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.lat)&lon=\(location.lon)&appid=\(APIkey)"
        let request = Observable<String>.of(urlString).map { urlString -> URL in
            return URL(string: urlString)!
        }.map { url -> URLRequest in
            return URLRequest(url: url)
        }.flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
            return URLSession.shared.rx.response(request: request)
        }.share(replay: 1)
        return request.filter { response, _ -> Bool in
            return response.statusCode.isSuccessStatus
        }.map { _, data -> WeatherCity in
            let result = try JSONDecoder().decode(WeatherCity.self, from: data)
            return result
        }
    }
    
    func getCityByName(with cityName: String) -> Observable<[City]> {
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=\(1)&appid=\(APIkey)"
        let request = Observable<String>.of(urlString).map { urlString -> URL in
            return URL(string: urlString)!
        }.map { url -> URLRequest in
            return URLRequest(url: url)
        }.flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
            return URLSession.shared.rx.response(request: request)
        }.share(replay: 1)
        return request.filter { response, _ -> Bool in
            return response.statusCode.isSuccessStatus
        }.map { _, data -> [City] in
            let result = try JSONDecoder().decode([City].self, from: data)
            return result
        }
    }
}

enum Status {
    case success, redirect, errorClient, errorBackend, unknown
}

extension Int {
    var httpStatus: Status {
        switch self {
        case 200...299: return .success
        case 300...399: return .redirect
        case 400...499: return .errorClient
        case 500...599: return .errorBackend
        default: return .unknown
        }
    }
    
    var isSuccessStatus: Bool {
        self.httpStatus == .success
    }
}
