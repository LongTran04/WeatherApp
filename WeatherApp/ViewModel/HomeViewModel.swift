//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Long Tran on 13/07/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct Location {
    let lat: Double
    let lon: Double
}

class HomeViewModel: ListViewModel<SFModel, WeatherNDCellViewModel> {
    let rxLocation = BehaviorRelay<Location?>(value: nil)
    let rxWeatherCity = PublishRelay<WeatherCity>()
    let rxWeatherND = BehaviorRelay<WeatherNextDay?>(value: nil)
    let rxSearchText = BehaviorRelay<String?>(value: nil)
    
    override func react() {
        rxLocation.subscribe(onNext: { [weak self] location in
            if let location = location {
                self?.getWeatherCity(location)
            }
        }) => disposeBag
        rxWeatherND.subscribe(onNext: { [weak self] wnd in
            self?.itemsSource.reset([wnd?.list.map {WeatherNDCellViewModel(model: $0)} ?? []])
        }) => disposeBag
        rxSearchText.distinctUntilChanged().subscribe(onNext: { [weak self] searchText in
            self?.searchAction(with: searchText ?? "")
        }) => disposeBag
    }
    
    func updateLocation(_ location: Location) {
        rxLocation.accept(location)
    }
    
    func getWeatherCity(_ location: Location) {
        MoyaAPIHelper.share.getWeatherCity(with: location) { [weak self] result in
            switch result {
            case .success(let weatherCity):
                self?.rxWeatherCity.accept(weatherCity)
            case .failure(let error):
                print(error)
            }
        }
        
        MoyaAPIHelper.share.getWeatherNextDay(with: location) { [weak self] result in
            switch result {
            case .success(let weatherNextDay):
                self?.rxWeatherND.accept(weatherNextDay)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchAction(with searchText: String) {
        APIHepler.shared.getCityByName(with: searchText) { [weak self] result in
            switch result {
            case .success(let cities):
                guard let city = cities.first, let lat = city.lat, let lon = city.lon else { return }
                self?.rxLocation.accept(Location(lat: lat, lon: lon))
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension Double {
    func convertTempToString() -> String {
        return "\((Int)(self - 272.15).description)°"
    }
}

extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
    
    var folded: String {
        return self.folding(options: .diacriticInsensitive, locale: nil)
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
    }
}
