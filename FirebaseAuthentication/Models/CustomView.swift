//
//  CustomView.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 05/05/21.
//

import UIKit

@IBDesignable class CustomView: UIView {
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var radius : CGFloat = 2.0{
        didSet{
            self.layer.cornerRadius = self.radius
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
}
