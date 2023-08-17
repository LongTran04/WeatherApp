//
//  WeatherNDTableViewCell.swift
//  WeatherApp
//
//  Created by Long Tran on 13/07/2023.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherNDTableViewCell: TableCell<WeatherNDCellViewModel> {
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let desWeatherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override func initialize() {
        super.initialize()
        setupUI()
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel else { return }
        viewModel.rxTime.map {$0?.convertToTimeText()} ~> timeLabel.rx.text => disposeBag
        viewModel.rxDes.map {$0?.capitalizedSentence} ~> desWeatherLabel.rx.text => disposeBag
        viewModel.rxTemp.map {$0?.convertTempToString()} ~> tempLabel.rx.text => disposeBag
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        contentView.addSubview(timeLabel)
        contentView.addSubview(desWeatherLabel)
        contentView.addSubview(tempLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        desWeatherLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            desWeatherLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            desWeatherLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 30),
            tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tempLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
        ])
    }
}
