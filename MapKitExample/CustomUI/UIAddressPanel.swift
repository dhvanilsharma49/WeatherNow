//
//  UIAddressPanel.swift
//  MapKitExample
//
//  Created by Daniel Carvalho on 23/02/22.
//

import UIKit

protocol UIAddressPanelDelegate {
    
    func addressPanelCloseButtonTapped()
    
}

// This extension turns the "addressPanelCloseButtonTapped" optional. You just
// use if you need (will not be mandatory as "stubs")
extension UIAddressPanelDelegate {
    
    func addressPanelCloseButtonTapped() {
        // no code
    }
    
}

class UIAddressPanel: UIView {

    public var delegate : UIAddressPanelDelegate?   // "initialized" with nil
    
    private let lblAddress : UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    private let imgClose : UIImageView = {
        
        let img = UIImageView()
        img.tintColor = .darkGray
        img.image = UIImage(systemName: "xmark")
        
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
        
    }()
    
    
    public var address : String = "" {
        didSet{
            self.lblAddress.text = address
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
        
        self.addSubviews(lblAddress, imgClose)
        
        imgClose.enableTapGestureRecognizer(target: self, action: #selector(imgCloseTapped))
        
        applyConstraints()
        
    }
    
    @objc private func imgCloseTapped() {
        
        if self.delegate != nil {
            self.delegate!.addressPanelCloseButtonTapped()
        }
        
    }
    
    private func applyConstraints() {
        
        // Leading   = Left
        // Trailing  = Right
        lblAddress.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        lblAddress.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        lblAddress.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        lblAddress.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        
        imgClose.leadingAnchor.constraint(equalTo: lblAddress.trailingAnchor, constant: 10).isActive = true
//        imgClose.trailingAnchor.constraint(equalTo: lblAddress.trailingAnchor, constant: -10).isActive = true
        imgClose.topAnchor.constraint(equalTo: lblAddress.topAnchor).isActive = true
        imgClose.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imgClose.widthAnchor.constraint(equalTo: imgClose.heightAnchor).isActive = true
        
        /*
        ----------------------
        | xxxxxxxxxxxxxxxx X |
        | xxxxxxxxxxxxxxxx   |
        ----------------------
        */
    }
    
    

}
