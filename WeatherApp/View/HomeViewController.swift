//
//  ViewController.swift
//  WeatherApp
//
//  Created by Long Tran on 28/06/2023.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import Alamofire

class HomeViewController: SFPage<HomeViewModel> {
    @IBOutlet weak var searchCity: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherNDTableView: UITableView!
    let homeVM = HomeViewModel()
    var homeTableBindingHelper: HomeTableBindingHelper?
    var locationManager: CLLocationManager?
    let wView = WeatherView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = homeVM
    }
    
    override func initialize() {
        super.initialize()
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        searchCity.layer.borderColor = UIColor.white.cgColor
        searchCity.layer.borderWidth = 1
        weatherView.addSubview(wView)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel else { return }
        homeTableBindingHelper = HomeTableBindingHelper(tableView: weatherNDTableView, viewModel: viewModel)
        searchBtn.rx.tap.subscribe(onNext: { [weak self] in
            viewModel.rxSearchText.accept(self?.searchCity.text)
        }) => disposeBag
        viewModel.rxWeatherCity.subscribe(onNext: { [weak self] weatherCity in
            self?.wView.updateVM(weatherCity)
        }) => disposeBag
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentLocation = Location(lat: Double(location.coordinate.latitude), lon: Double(location.coordinate.longitude))
            viewModel?.updateLocation(currentLocation)
        }
    }
}

class HomeTableBindingHelper: TableBindingHelper<HomeViewModel> {
    override func initialize() {
        tableView.register(WeatherNDTableViewCell.self, forCellReuseIdentifier: WeatherNDTableViewCell.identifier)
    }
    
    override func cellIdentifier(_ cellViewModel: TableBindingHelper<HomeViewModel>.CVM) -> String {
        return WeatherNDTableViewCell.identifier
    }
}
