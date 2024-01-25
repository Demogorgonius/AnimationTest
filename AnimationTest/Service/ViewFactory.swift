//
//  ViewFactory.swift
//  AnimationTest
//
//  Created by Sergey on 01.01.2024.
//

import Foundation
import UIKit

protocol ColorView: AnyObject {
    
    var shadowColorView: UIView {get}
    
}

extension UIView: ColorView {
    
    var shadowColorView: UIView {
       return self
    }
    
}

class ColorViewFactory {
    
    static func createShadowView() -> ColorView {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.9
        view.layer.shadowRadius = 3
        view.layer.shadowColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func getRandomColor() -> UIColor {
        
        let colors: [UIColor] = [.red, .gray, .black, .blue, .brown, .purple]
        return colors[Int.random(in: 0 ... colors.count-1)]
        
    }
    
    
    
}
