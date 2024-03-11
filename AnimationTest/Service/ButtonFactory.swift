//
//  ButtonFactory.swift
//  AnimationTest
//
//  Created by Sergey on 23.02.2024.
//

import Foundation
import UIKit

protocol ColorButton: AnyObject {
    
    var shadowColorButton: UIButton {get}
    
}

extension UIButton: ColorButton {
    
    var shadowColorButton: UIButton {
       return self
    }
    
}





class ColorButtonFactory {

    let colors: [UIColor] = [.red, .gray, .black, .blue, .brown, .purple, .green]
    
    static func makeShadowButton(
        backgroundColor: UIColor,
        title: String?,
        target: Any?,
        tag: Int,
        action: Selector?
    ) -> ColorButton {
        
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.9
        button.layer.shadowRadius = 3
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.tag = tag
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        
        return button
    }
    
    func getColor(_ index: Int) -> UIColor {
        
        return colors[index]
        
    }
    
}

