//
//  APIHepler.swift
//  WeatherApp
//
//  Created by Long Tran on 28/06/2023.
//

import Foundation

class APIHepler {
    static var shared = APIHepler()
    private let APIkey = "9dab31bf2ab32e86722c3e6f3e28ac2d"
    
    func getWeatherCity(with location: Location, completion: @escaping (Result<WeatherCity, Error>) -> Void){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.lat)&lon=\(location.lon)&appid=\(APIkey)"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let result = try JSONDecoder().decode(WeatherCity.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getCityByName(with cityName: String, completion: @escaping (Result<[City], Error>) -> Void ) {
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=\(1)&appid=\(APIkey)"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                let results = try JSONDecoder().decode([City].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

