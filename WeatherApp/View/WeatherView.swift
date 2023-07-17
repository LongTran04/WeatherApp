//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Long Tran on 03/07/2023.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherView: SFView<WeatherViewModel> {
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    let tempLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 54)
        return label
    }()
    let weatherDescLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    let tempMaxLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let tempMinLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override func initialize() {
        super.initialize()
        setupUI()
    }
    
    override init(frame: CGRect, viewModel: WeatherViewModel? = nil) {
        super.init(frame: frame, viewModel: viewModel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel else { return }
        Observable.combineLatest(viewModel.rxCityName, viewModel.rxCountryName)
            .map { "\($0 ?? ""), \($1 ?? "")" } ~> cityNameLabel.rx.text => disposeBag
        viewModel.rxTemp.map {$0?.convertTempToString()} ~> tempLabel.rx.text => disposeBag
        viewModel.rxWeatherDesc.map {$0?.capitalizedSentence} ~> weatherDescLabel.rx.text => disposeBag
        viewModel.rxMaxTemp.map {"Max: \($0?.convertTempToString() ?? "")"} ~> tempMaxLabel.rx.text => disposeBag
        viewModel.rxMinTemp.map {"Min: \($0?.convertTempToString() ?? "")"} ~> tempMinLabel.rx.text => disposeBag
    }
    
    func setupUI() {
        addSubview(cityNameLabel)
        addSubview(tempLabel)
        addSubview(weatherDescLabel)
        addSubview(tempMaxLabel)
        addSubview(tempMinLabel)
        
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescLabel.translatesAutoresizingMaskIntoConstraints = false
        tempMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        tempMinLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherDescLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 10),
            weatherDescLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempMinLabel.topAnchor.constraint(equalTo: weatherDescLabel.bottomAnchor, constant: 10),
            tempMinLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -50),
            tempMaxLabel.topAnchor.constraint(equalTo: weatherDescLabel.bottomAnchor, constant: 10),
            tempMaxLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 50)
        ])
    }
    
    func updateVM(_ model: WeatherCity) {
        let vm = WeatherViewModel(model: model)
        self.viewModel = vm
    }
}
