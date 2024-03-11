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
    
    let colors: [UIColor] = [.red, .gray, .black, .blue, .brown, .purple, .green]
    
    static func createShadowView() -> ColorView {
        let view = UIView()
        view.backgroundColor = Colors.black.colorRowValue
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
        
        return colors[Int.random(in: 0 ... colors.count-1)]
        
    }
    
    func getColor(_ index: Int) -> UIColor {
        
        return colors[index]
        
    }
    
    func getCurentIndex(_ color: UIColor) -> Int {
        
        let index: Int = colors.firstIndex(of: color) ?? 0
        
        return index
        
    }
    
    
}
