//
//  Colors.swift
//  AnimationTest
//
//  Created by Sergey on 07.03.2024.
//

import Foundation
import UIKit

protocol ColorConvertible {
    var colorDescription: String { get }
    var colorRowValue: UIColor { get }
}

enum Colors: CaseIterable {
   
    case red, gray, black, blue, brown, purple, green
    
}

extension Colors: ColorConvertible {
    
    var colorDescription: String {
        switch self {
        case .red:
            return "красный"
        case .gray:
            return "серый"
        case .black:
            return "черный"
        case .blue:
            return "голубой"
        case .brown:
            return "коричневый"
        case .purple:
            return "фиолетовый"
        case .green:
            return "зелёный"
        }
    }
    
    var colorRowValue: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .gray:
            return UIColor.gray
        case .black:
            return UIColor.black
        case .blue:
            return UIColor.blue
        case .brown:
            return UIColor.brown
        case .purple:
            return UIColor.purple
        case .green:
            return UIColor.green
        }
    }
    
    func getRandomColor() -> Colors {
        
        guard let color = Colors.allCases.randomElement() else { return Colors.black}
        return color
        
    }
    
    func returnColorsByColor(_ color: UIColor) -> Colors {
        
        
        var colors = Colors.red
        Self.allCases.forEach {colorCase in
            if colorCase.colorRowValue == color {
                colors = colorCase
            }
        }
        return colors

    }
    
    func returnColorsByText(_ string: String) -> Colors {
        
        var colors = Colors.gray
        Self.allCases.forEach {colorCase in
            if colorCase.colorDescription == string {
                colors = colorCase
            }
        }
        return colors
        
    }
    
}


