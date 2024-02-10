//
//  MainBuilder.swift
//  AnimationTest
//
//  Created by Sergey on 30.12.2023.
//

import Foundation
import UIKit

protocol MainBuilderProtocol: AnyObject {
    
    func buildMain() -> UIViewController
    init(navigationVC: UINavigationController)
    
}

class MainBuilder: MainBuilderProtocol {
    
    weak var navigationVC: UINavigationController?
    
    required init(navigationVC: UINavigationController) {
        self.navigationVC = navigationVC
    }
    
    func buildMain() -> UIViewController {
        
        guard let navigationVC = navigationVC else { 
            fatalError("MainBuilder requires a valid navigationController")
        }
        let vc = MainViewController()
        let router = MainRouter(navigationVC: navigationVC)
        let stateManager = StateManager()
        let presenter = MainPresenter(router: router, stateManager: stateManager)
        vc.presenter = presenter
        
        return vc
    }
    
}
