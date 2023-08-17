//
//  WeatherNextDay.swift
//  WeatherApp
//
//  Created by Long Tran on 17/08/2023.
//

import Foundation

// MARK: - WeatherNextDay
struct WeatherNextDay: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ListWeather]
    let city: City
}

// MARK: - List
struct ListWeather: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}



