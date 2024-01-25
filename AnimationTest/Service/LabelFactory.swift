//
//  LabelFactory.swift
//  AnimationTest
//
//  Created by Sergey on 04.01.2024.
//

import Foundation
import UIKit

protocol ColorLabel: AnyObject {
    
    var shadowColorLabel: UILabel {get}
    
}

extension UILabel: ColorLabel {
    
    var shadowColorLabel: UILabel {
       return self
    }
    
}

class ColorLabelFactory {
    
    static func createShadowLabel() -> ColorLabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 3
        label.layer.shadowColor = UIColor.black.cgColor
        label.textAlignment = .center
        return label
    }
    
    func getRandomColor() -> String {
        
        let colours: [String] = ["красный", "серый", "чёрный", "синий", "коричневый", "фиолетовый"]
        return colours[Int.random(in: 0 ... colours.count-1)]
        
    }
    
    
    
}
