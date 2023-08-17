//
//  WeatherNDCellViewModel.swift
//  WeatherApp
//
//  Created by Long Tran on 13/07/2023.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherNDCellViewModel: CellViewModel<ListWeather> {
    let rxTime = BehaviorRelay<Int?>(value: nil)
    let rxDes = BehaviorRelay<String?>(value: nil)
    let rxTemp = BehaviorRelay<Double?>(value: nil)
    
    override func react() {
        guard let model = model else { return }
        rxTime.accept(model.dt)
        rxDes.accept(model.weather.first?.description)
        rxTemp.accept(model.main.temp)
    }
}

extension Int {
    func convertToTimeText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return formatter.string(from: date)
    }
}
