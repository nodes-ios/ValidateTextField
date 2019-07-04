//
//  Colors.swift
//  ValidateTextField
//
//  Created by Andrei Hogea on 03/07/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var errorColor: UIColor {
        
        if #available(iOS 13.0, *) {
            return UIColor{ (traitCollection: UITraitCollection) -> UIColor in
                // resolve the color by using traitCollection
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 176/255, green: 0/255, blue: 32/255, alpha: 1)
                case .light, .unspecified:
                    return .red
                @unknown default: // may have additional userInterfaceStyles in the future
                    return .red
                }
            }
        } else {
            return .red
        }
        
    }
    
    static var headerInFocusColor: UIColor {
        
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
        
    }
    
    static var headerOffFocusColor: UIColor {
        
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return UIColor.black.withAlphaComponent(0.6)
        }
        
    }
    
    static var textColor: UIColor {
        
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
        
    }
    
    static var placeholderColor: UIColor {
        
        if #available(iOS 13.0, *) {
           return .systemGray2
        } else {
            return UIColor.black.withAlphaComponent(0.6)
        }
        
    }
    
    static var backgroundColor: UIColor {
        
        if #available(iOS 13.0, *) {
            return .secondarySystemBackground
        } else {
            return .white
        }
        
    }
    
    static var borderInFocusColor: UIColor {
        
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
        
    }
    
    static var borderOffFocusColor: UIColor {
        
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
        
    }
}
