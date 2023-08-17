//
//  City.swift
//  WeatherApp
//
//  Created by Long Tran on 17/08/2023.
//

import Foundation

struct City: Codable {
    let id: Int?
    let name: String
    let localNames: [String: String]?
    let lat, lon: Double?
    let country, state: String?
    let coord: Coord?
    let population, timezone, sunrise, sunset: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
        case population, timezone, sunrise, sunset
        case coord
        case id 
    }
}
