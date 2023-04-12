//
//  UICoordinatePanel.swift
//  MapKit
//
//  Created by Daniel Carvalho on 17/02/22.
//

import UIKit

protocol UICoordinatePanelProtocol {
    
    func CoordinatePanelMapCenterTapped()
    
}

extension UICoordinatePanelProtocol {
    
    func CoordinatePanelMapCenterTapped() {
        // nothing here
    }
    
}


class UICoordinatePanel: UIView {

    var delegate : UICoordinatePanelProtocol?
    
    static private func defaultLabel( text : String, bold : Bool = false) -> UILabel {
        
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = .black
        lbl.textAlignment = .left
        
        // Ternary operator
        lbl.font = bold ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        
        lbl.text = text
        
        // We need to apply constraints programmatically
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
        
    }
    
    
    private var lblLongitudeTitle : UILabel = UICoordinatePanel.defaultLabel(text: "Longitude")
    
    private var lblLatitudeTitle : UILabel = UICoordinatePanel.defaultLabel(text: "Latitude")
    
    private var lblLongitude : UILabel = UICoordinatePanel.defaultLabel(text: "?", bold: true)
    
    private var lblLatitude : UILabel = UICoordinatePanel.defaultLabel(text: "?", bold: true)
    
    
    private var imgMapCenter : UIImageView = {
        
        var img = UIImageView()
        
        img.image = UIImage(systemName: "target")
        img.tintColor = .black
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
        
    }()
    
    
    public var longitude : Double = 0 {
        didSet{
            lblLongitude.text = String(format: "%.6f", longitude)
        }
    }
   
    public var latitude : Double = 0 {
        didSet{
            lblLatitude.text = String(format: "%.6f", latitude)
        }
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
        
        self.backgroundColor = .white.withAlphaComponent(0.7)
        
        self.addSubviews(lblLatitudeTitle, lblLatitude, lblLongitudeTitle, lblLongitude, imgMapCenter)
                
        // adding tap recognizer to our UIImageView
        self.imgMapCenter.enableTapGestureRecognizer(target: self, action: #selector(imgMapCenterTapped))
        
        // Apply constraints
        applyConstraints()
        
    }
    
    
    @objc private func imgMapCenterTapped() {
        
        delegate!.CoordinatePanelMapCenterTapped()
        
    }
    
    private func applyConstraints() {
        
        lblLatitudeTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        lblLatitudeTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        lblLatitudeTitle.trailingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lblLatitudeTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        lblLongitudeTitle.leadingAnchor.constraint(equalTo: lblLatitudeTitle.trailingAnchor).isActive = true
        lblLongitudeTitle.topAnchor.constraint(equalTo: lblLatitudeTitle.topAnchor).isActive = true
        lblLongitudeTitle.widthAnchor.constraint(equalTo: lblLatitudeTitle.widthAnchor).isActive = true
        lblLongitudeTitle.heightAnchor.constraint(equalTo: lblLatitudeTitle.heightAnchor).isActive = true
        
        
        lblLatitude.leadingAnchor.constraint(equalTo: lblLatitudeTitle.leadingAnchor).isActive = true
        lblLatitude.topAnchor.constraint(equalTo: lblLatitudeTitle.bottomAnchor).isActive = true
        lblLatitude.widthAnchor.constraint(equalTo: lblLatitudeTitle.widthAnchor).isActive = true
        lblLatitude.heightAnchor.constraint(equalTo: lblLatitudeTitle.heightAnchor).isActive = true
        
        
        lblLongitude.leadingAnchor.constraint(equalTo: lblLongitudeTitle.leadingAnchor).isActive = true
        lblLongitude.topAnchor.constraint(equalTo: lblLongitudeTitle.bottomAnchor).isActive = true
        lblLongitude.widthAnchor.constraint(equalTo: lblLongitudeTitle.widthAnchor).isActive = true
        lblLongitude.heightAnchor.constraint(equalTo: lblLongitudeTitle.heightAnchor).isActive = true
        
        
        imgMapCenter.trailingAnchor.constraint(equalTo: lblLongitude.trailingAnchor).isActive = true
        imgMapCenter.centerYAnchor.constraint(equalTo: lblLongitude.topAnchor).isActive = true
        imgMapCenter.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imgMapCenter.widthAnchor.constraint(equalTo: imgMapCenter.heightAnchor).isActive = true
        
        
        
    }
    
    
}
