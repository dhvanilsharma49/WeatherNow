//
//  UIWeatherPanel.swift
//  MapKitExample
//
//  Created by Daniel Carvalho on 04/03/22.
//

import UIKit

class UIWeatherPanel: UIView {


    static private func defaultLabel( text : String, fontSize : CGFloat = 16, fontBold : Bool = false, numberOfLines : Int = 1 ) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = numberOfLines
        label.textColor = .darkGray
        
        // Ternary condition/expression  "? : "
        label.font = fontBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        /* same thing as ...
        if fontBold {
            label.font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
         */
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }
    
    
    private var lblTemperatureValue : UILabel = defaultLabel(text: "??", fontSize: 30, fontBold: true)
    private var lblTemperatureUnit : UILabel = defaultLabel(text: "C", fontSize: 10)
    
    private var lblFeelsLikeTitle : UILabel = defaultLabel(text: "feels like", fontSize: 10, numberOfLines: 2)
    private var lblFeelsLikeValue : UILabel = defaultLabel(text: "??", fontSize: 20, fontBold: true)
    
    private let lblCondition : UILabel = defaultLabel(text: "light snow", fontSize: 12, numberOfLines: 2)
    
    private let imgWeather : UIImageView = {
        
        let img = UIImageView()
        img.tintColor = .black
        img.image = UIImage(systemName: "cloud")
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    
    public var temperature : String = "" {
        didSet{
            lblTemperatureValue.text = temperature
        }
    }
    
    public var temperatureUnit : String = "" {
        didSet{
            lblTemperatureUnit.text = temperatureUnit
        }
    }
    
    
    public var feelsLike : String = "" {
        didSet{
            lblFeelsLikeValue.text = feelsLike
        }
    }
    
    public var condition : String = "" {
        didSet{
            lblCondition.text = condition
        }
    }
    
    public var image : UIImage? = UIImage(systemName: "cloud") {
        didSet{
            imgWeather.image = image
        }
    }

    public func imageFromUrl ( url : String ) {
        // we are using our extension "fetchUIImageFromURL"
        imgWeather.fetchUImageFromURL(url: URL(string: url)!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white.withAlphaComponent(0.70)
        
        self.layer.cornerRadius = 15
        
        self.addSubviews(imgWeather, lblTemperatureValue, lblTemperatureUnit, lblCondition, lblFeelsLikeTitle, lblFeelsLikeValue)
        
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        
        self.heightAnchor.constraint(equalToConstant: 185).isActive = true
        self.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        
        imgWeather.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        imgWeather.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imgWeather.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imgWeather.widthAnchor.constraint(equalTo: imgWeather.heightAnchor).isActive = true
        
        
        lblTemperatureValue.topAnchor.constraint(equalTo: imgWeather.bottomAnchor, constant: 10).isActive = true
        lblTemperatureValue.centerXAnchor.constraint(equalTo: imgWeather.centerXAnchor).isActive = true
        lblTemperatureValue.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lblTemperatureValue.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor).isActive = true
        lblTemperatureValue.textAlignment = .center
        
        
        
        lblTemperatureUnit.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5 ).isActive = true
        lblTemperatureUnit.bottomAnchor.constraint(equalTo: lblTemperatureValue.bottomAnchor).isActive = true
        lblTemperatureUnit.heightAnchor.constraint(equalToConstant: 10).isActive = true
        lblTemperatureUnit.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        
        lblCondition.topAnchor.constraint(equalTo: lblTemperatureValue.bottomAnchor, constant: 10).isActive = true
        lblCondition.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        lblCondition.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        lblCondition.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lblCondition.textAlignment = .center
        
        
        lblFeelsLikeTitle.leadingAnchor.constraint(equalTo: lblCondition.leadingAnchor).isActive = true
        lblFeelsLikeTitle.topAnchor.constraint(equalTo: lblCondition.bottomAnchor, constant: 10).isActive = true
        lblFeelsLikeTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        lblFeelsLikeTitle.widthAnchor.constraint(equalToConstant: 32).isActive = true
        lblFeelsLikeTitle.textAlignment = .center
                
        
        lblFeelsLikeValue.leadingAnchor.constraint(equalTo: lblFeelsLikeTitle.trailingAnchor).isActive = true
        lblFeelsLikeValue.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        lblFeelsLikeValue.topAnchor.constraint(equalTo: lblFeelsLikeTitle.topAnchor).isActive = true
        lblFeelsLikeValue.heightAnchor.constraint(equalTo: lblFeelsLikeTitle.heightAnchor).isActive = true
        lblFeelsLikeValue.textAlignment = .right
        
        
    }
    
}
