//
//  WeatherViewViewModel.swift
//  WeatherApp
//
//  Created by Long Tran on 13/07/2023.
//

import Foundation
import RxCocoa
import RxSwift

class WeatherViewModel: ViewModel<WeatherCity> {
    let rxCityName = BehaviorRelay<String?>(value: nil)
    let rxCountryName = BehaviorRelay<String?>(value: nil)
    let rxTemp = BehaviorRelay<Double?>(value: nil)
    let rxWeatherDesc = BehaviorRelay<String?>(value: nil)
    let rxMaxTemp = BehaviorRelay<Double?>(value: nil)
    let rxMinTemp = BehaviorRelay<Double?>(value: nil)
    
    override func react() {
        guard let model = model else { return }
        rxCityName.accept(model.name)
        rxCountryName.accept(model.sys.country)
        rxTemp.accept(model.main.temp)
        rxWeatherDesc.accept(model.weather.first?.description)
        rxMaxTemp.accept(model.main.tempMax)
        rxMinTemp.accept(model.main.tempMin)
    }
    
}
