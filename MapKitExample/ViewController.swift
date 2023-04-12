//  TEJVIR SINGH     - 2013829
//  DHVANIL SHARMA   - 2012859
//  ATUL RANA        - 2014382


//  ViewController.swift
//  MapKit
//
//

import UIKit
import MapKit

/*
 ok 1. Update our coordinatePanel
 ok 2. Pin the position
 ok 3. Center the map when "target" button is
 tapped
 4. Create UIAddressPanel
 5. Fetch the address using geocoding
 (coordinates)
 
 */

class ViewController: UIViewController, UICoordinatePanelProtocol, CLLocationManagerDelegate, MKMapViewDelegate, UIAddressPanelDelegate {
    
    private var mySlider = UISlider()
    
    private var mapView : MKMapView = MKMapView()
    
    private var locationManager = CLLocationManager()
    
    private var coordinate = CLLocationCoordinate2D()
    
    private var coordinatePanel : UICoordinatePanel = UICoordinatePanel()
    
    private var addressPanel : UIAddressPanel = UIAddressPanel()
    
    private var weatherPanel : UIWeatherPanel = UIWeatherPanel()
    
    private var timer = Timer()
    
    public var tempC : String!
    public var tempF : String!
    public var feelsLikeC : String!
    public var feelsLikeF : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.updateF), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(self.UpdateInfo), userInfo: nil, repeats: true)
        
        initialize()
        
    }
    
    
    private func initialize(){
        
        self.mySlider = CreateSlider()
        self.mySlider.value = Float(self.mapView.region.span.latitudeDelta)
        
        self.view.addSubviews(self.mapView, self.coordinatePanel, self.addressPanel, self.weatherPanel, self.mySlider)
        
        self.coordinatePanel.delegate = self
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        self.addressPanel.delegate = self
        
        self.weatherPanel.isHidden = true
        
        
        applyConstraints()
        
        
    }
    
    func CreateSlider() -> UISlider {
        let slider = UISlider()
        slider.maximumValue = 0.1
        slider.minimumValue = 0.001
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        slider.isContinuous = true
        slider.tintColor = .red
        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        return slider
    }
    
    @objc func sliderValueDidChange(_ sender : UISlider) {
        var miles = Double(self.mySlider.value)
        miles = Double(self.mySlider.maximumValue) - miles
        var currentRegion = self.mapView.region
        currentRegion.span = MKCoordinateSpan(latitudeDelta: miles, longitudeDelta: miles)
        self.mapView.region = currentRegion
        
    }
    
    private func applyConstraints() {
        
        coordinatePanel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        coordinatePanel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        coordinatePanel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        coordinatePanel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        addressPanel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
        addressPanel.trailingAnchor.constraint(equalTo: mapView.trailingAnchor).isActive = true
        addressPanel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        addressPanel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        weatherPanel.leadingAnchor.constraint(equalTo: coordinatePanel.leadingAnchor).isActive = true
        weatherPanel.topAnchor.constraint(equalTo: coordinatePanel.bottomAnchor, constant: 20).isActive = true
        
        
        mySlider.leadingAnchor.constraint(equalTo: addressPanel.leadingAnchor, constant: 15).isActive = true
        mySlider.trailingAnchor.constraint(equalTo: addressPanel.trailingAnchor, constant: -15).isActive = true
        mySlider.bottomAnchor.constraint(equalTo: addressPanel.bottomAnchor).isActive = true
        
    }
    
    func CoordinatePanelMapCenterTapped() {
        
        startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startUpdatingLocation()   // call the location manager to get gps/position
        
    }
    
    func startUpdatingLocation() {
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization() // ask the user for permission
        self.locationManager.startUpdatingLocation()  // starts pooling the location
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            self.locationManager.stopUpdatingLocation()  // stops the location pooling
            
            setMapLocation(location: location)
            
        }
        
    }
    
    func setMapLocation( location : CLLocation ) {
        
        self.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        showMap( coordinate: self.coordinate, latLongDelta : 0.002 )
        
        
        coordinatePanel.longitude = location.coordinate.longitude
        coordinatePanel.latitude = location.coordinate.latitude
        
        
        locationManager.getAddress(from: self.coordinate, successHandler: locationManagerGetAddressSuccess, failHandler: locationManagerGetAddressFail)
        
        
        
        // Pin the position
        let pin = MKPointAnnotation()
        pin.title = "You are here!"
        pin.subtitle = "This is the subtitle"
        pin.coordinate = self.coordinate
        mapView.addAnnotation(pin)
        
    }
    
    
    func locationManagerGetAddressSuccess(_ address : String, _ city : String){
        
        addressPanel.address = address
        addressPanel.isHidden = false
        
        WeatherAPI.weatherNow(city: city, successHandler: weatherNowSuccessHandler, failHandler: weatherNowFailHandler)
        
    }
    
    func weatherNowSuccessHandler(_ httpStatusCode : Int, _ response : [String: Any]) {
        
        if httpStatusCode == 200 {
            
            guard let current = response["current"] as? [String: Any] else {
                return
            }
            
            if let currentWeather = WeatherAPICurrent.decode(json: current){
                
                DispatchQueue.main.async {
                    self.weatherPanel.temperature = String(format:"%.0f", currentWeather.temp_c)
                    self.weatherPanel.feelsLike = String(format:"%.0f", currentWeather.feelslike_c)
                    self.weatherPanel.condition = currentWeather.condition.text
                    self.weatherPanel.imageFromUrl(url: "https:\(currentWeather.condition.icon)")
                    
                    self.weatherPanel.isHidden = false
                    
                    self.tempF = String(format:"%.0f", currentWeather.temp_f)
                    self.feelsLikeF = String(format:"%.0f", currentWeather.feelslike_f)
                    self.tempC = String(format:"%.0f", currentWeather.temp_c)
                    self.feelsLikeC = String(format:"%.0f", currentWeather.feelslike_c)
                }
                
            }
        }
        
    }
    
    func weatherNowFailHandler(_ httpStatusCode : Int, _ errorMessage: String) {
        
        DispatchQueue.main.async {
            self.weatherPanel.isHidden = true
        }
        
    }
    
    
    
    
    func locationManagerGetAddressFail() {
        
        print("Error fetching address")
        
    }
    
    func showMap( coordinate : CLLocationCoordinate2D, latLongDelta : Float) {
        
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(latLongDelta), longitudeDelta: CLLocationDegrees(latLongDelta))
        // MKCoordinateSpan is the width and height in degress for the mapview.
        // 0.001 is street level and 1-10 is a zoom out
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    func addressPanelCloseButtonTapped() {
        
        self.addressPanel.isHidden = true
        
    }
    
    @objc func updateF() {
        self.weatherPanel.temperature = tempF
        self.weatherPanel.feelsLike = feelsLikeF
        self.weatherPanel.temperatureUnit = "F"
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.updateC), userInfo: nil, repeats: true)
    }
    @objc func updateC() {
        self.weatherPanel.temperature = tempC
        self.weatherPanel.feelsLike = feelsLikeC
        self.weatherPanel.temperatureUnit = "C"
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.updateF), userInfo: nil, repeats: true)
    }
    @objc func UpdateInfo() {
        self.locationManager.startUpdatingLocation()
    }
    
}



