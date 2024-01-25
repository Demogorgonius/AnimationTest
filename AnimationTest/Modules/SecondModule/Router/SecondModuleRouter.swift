//
//  SecondModuleRouter.swift
//  AnimationTest
//
//  Created by Sergey on 31.12.2023.
//

import Foundation
import UIKit

protocol SecondModuleRouterProtocol: AnyObject {
    
    init(navigationVC: UINavigationController)
    func goToStartScreen()
    
}

class SecondModuleRouter: SecondModuleRouterProtocol {
    
   weak var navigationVC: UINavigationController!
    
    required init(navigationVC: UINavigationController) {
        
        self.navigationVC = navigationVC
        
    }
    
    func goToStartScreen() {
        navigationVC.popToRootViewController(animated: true)
    }
    
}
